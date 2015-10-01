require 'open-uri'
require 'pp'

class UrlMapper
  include Indexable

  self.mappings = {
    url_mapper: {
      _timestamp: {
        enabled: true,
        store:   true,
      },
      dynamic:    'false',
      properties: {
        link:         { type: 'string', index: 'not_analyzed' },
        long_url:     { type: 'string', index: 'not_analyzed' },
        title:        { type: 'string', analyzer: 'standard' },
        description:  { type: 'string', analyzer: 'standard' }
      },
    },
  }.freeze

  def self.process_url(url_string, title)
    encoded_url = CGI.escape(url_string)
    bitly_api_request = "https://api-ssl.bitly.com/v3/user/link_save?access_token=#{Rails.configuration.bitly_api_token}&longUrl=#{encoded_url}&title=#{title}"
    indexable_json = build_json(url_string, title)
    search_result = search_for_url(url_string)[:hits]

    if (search_result.count == 1)
      first_entry = search_result.first[:_source]
      short_link = entry_needs_update?(first_entry, title) ? call_bitly_api(bitly_api_request, url_string) : first_entry[:link]
      update([indexable_json.merge({link: short_link})]) if short_link != url_string
      return short_link
    elsif (search_result.count == 0)
      short_link = call_bitly_api(bitly_api_request, url_string)
      index([indexable_json.merge({link: short_link})]) if short_link != url_string
      return short_link
    else
      raise "More than 1 search result, entries should be unique by long_url!"
    end
  end

  def self.entry_needs_update?(entry, title)
    entry[:title] != title
  end

  def self.build_json(url_string, title)
    {
      id: Digest::SHA1.hexdigest(url_string), 
      long_url: url_string, 
      title: title, 
    }
  end

  def self.call_bitly_api(request_string, url_string)
    sleep 5 if !Rails.env.test?
    response = JSON.parse(open(request_string).read)

    return url_string if response["status_code"].to_i == 500

    # Not sure if there's a sensible way to test this...
    # :nocov:
    while (response["status_txt"] == "RATE_LIMIT_EXCEEDED")# || response["status_txt"] == "ALREADY_A_BITLY_LINK")
      Rails.logger.info "Rate limit exceeded, pausing for 60 seconds."
      sleep 60
      response = JSON.parse(open(request_string).read)
    end
    # :nocov:
    begin
      return response["data"]["link_save"]["link"]
    rescue
      raise "Invalid Bitly API Response: " + response.to_s
    end
  end

  def self.search_for_url(url_string)
    search_options = {
      index: index_name,
      type:  index_type,
      body:  generate_search_body(url_string)
    }

    hits = ES.client.search(search_options)['hits'].deep_symbolize_keys
  end

  def self.generate_search_body(url_string)
    Jbuilder.encode do |json|
      json.filter do
        json.bool do
          json.must do
            json.child! { json.term { json.long_url url_string } }
          end
        end
      end
    end
  end

  def self.purge_old
    fail 'This model is unable to purge old documents' unless can_purge_old?
    body = {
      query: {
        filtered: {
          filter: {
            range: {
              _timestamp: {
                lt: "now-2M",
              },
            },
          },
        },
      },
    }

    ES.client.delete_by_query(index: index_name, body: body)
  end

end