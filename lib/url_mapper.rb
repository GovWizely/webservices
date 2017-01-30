require 'open-uri'

class UrlMapper
  include Indexable

  BITLY_BASE_URL = "https://api-ssl.bitly.com/v3/user/link_save?access_token=#{Rails.configuration.bitly_api_token}"
  self.settings = {}
  self.mappings = {
    url_mapper: {
      dynamic:    'false',
      properties: {
        _updated_at: { type: 'date' },
        link:        { type: 'keyword' },
        long_url:    { type: 'keyword' },
        title:       { type: 'text', analyzer: 'standard' },
        description: { type: 'text', analyzer: 'standard' },
      },
    },
  }.freeze

  def self.get_bitly_url(url_string, model_class)
    url_string = "http://#{url_string}" unless url_string[/^https?/]

    return url_string unless Rails.application.config.enable_bitly_lookup

    Rails.cache.fetch("#{model_class}/#{url_string}", expires_in: 60.minutes) do
      UrlMapper.process_url(url_string, model_class.to_s)
    end
  end

  def self.process_url(url_string, title)
    encoded_url = CGI.escape(url_string)
    bitly_api_request = BITLY_BASE_URL + "&longUrl=#{encoded_url}&title=#{title}"
    search_result = search_for_url(url_string)[:hits]

    if search_result.count == 1
      return update_url(url_string, title, search_result, bitly_api_request)
    elsif search_result.count == 0
      return index_url(url_string, title, bitly_api_request)
    else
      raise 'More than 1 search result, entries should be unique by long_url!'
    end
  end

  def self.update_url(url_string, title, search_result, request_string)
    first_entry = search_result.first[:_source]
    short_link = entry_needs_update?(first_entry, title) ? call_bitly_api(request_string, url_string) : first_entry[:link]
    update([build_json(url_string, title).merge(link: short_link)]) if short_link != url_string
    short_link
  end

  def self.index_url(url_string, title, request_string)
    short_link = call_bitly_api(request_string, url_string)
    index([build_json(url_string, title).merge(link: short_link)]) if short_link != url_string
    short_link
  end

  def self.entry_needs_update?(entry, title)
    entry[:title] != title
  end

  def self.build_json(url_string, title)
    {
      id:       Digest::SHA1.hexdigest(url_string),
      long_url: url_string,
      title:    title,
    }
  end

  def self.call_bitly_api(request_string, url_string)
    sleep 5 unless Rails.env.test?
    response = JSON.parse(open(request_string).read)

    return url_string if response['status_txt'] == 'ALREADY_A_BITLY_LINK' || response['status_txt'] == 'INVALID_URI'
    # Not sure if there's a sensible way to test this...
    # :nocov:
    while response['status_txt'] == 'RATE_LIMIT_EXCEEDED'
      Rails.logger.info 'Rate limit exceeded, pausing for 60 seconds.'
      sleep 60
      response = JSON.parse(open(request_string).read)
    end
    # :nocov:
    validate_response(response, request_string)
  end

  def self.validate_response(response, request_string)
    return response['data']['link_save']['link']
  rescue
    raise 'Invalid Bitly API Response: ' + response.to_s + '.  Request: ' + request_string.to_s
  end

  def self.search_for_url(url_string)
    search_options = {
      index: index_name,
      type:  index_type,
      body:  generate_search_body(url_string),
    }

    ES.client.search(search_options)['hits'].deep_symbolize_keys
  end

  def self.generate_search_body(url_string)
    Jbuilder.encode do |json|
      json.query do
        json.constant_score do
          json.filter do
            json.term do
              json.long_url url_string
            end
          end
        end
      end
    end
  end

  def self.purge_old
    raise 'This model is unable to purge old documents' unless can_purge_old?
    body = Utils.older_than(:_updated_at, 'now-2M')
    ES.client.delete_by_query(index: index_name, body: body)
    ES.client.indices.refresh(index: index_name)
  end
end
