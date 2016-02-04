require 'open-uri'

module TradeLead
  class McaData
    include Importable
    include VersionableResource
    ENDPOINT = 'http://www.dgmarket.com/tenders/RssFeedAction.do?locationISO=&keywords=Millennium+Challenge+Account&sub=&noticeType=gpn%2cpp%2cspn%2crfc&language'
    FUNDING_SOURCE = 'Millennium Challenge Account (MCA)'

    SINGLE_VALUED_XPATHS = {
      title:        './title',
      url:          './link',
      description:  './description',
      publish_date: './pubDate',
    }.freeze

    MULTI_VALUED_XPATHS = {
      categories: './category',
    }

    def import
      document = Nokogiri::XML(open(@resource))
      leads = document.xpath('rss/channel/item').map { |item| process_entry item }.compact
      TradeLead::Mca.index leads
    end

    private

    def process_entry(item)
      item_hash = extract_fields(item, SINGLE_VALUED_XPATHS)
      item_hash.reverse_merge! extract_multi_valued_fields(item, MULTI_VALUED_XPATHS)
      process_geo_fields(item_hash)

      begin
        item_hash[:publish_date] = Date.parse(item_hash[:publish_date]).iso8601
      rescue ArgumentError
        item_hash[:publish_date] =  nil
      end
      item_hash[:funding_source] = FUNDING_SOURCE
      item_hash[:source] = TradeLead::Mca.source[:code]
      item_hash = process_urls(item_hash)
      item_hash
    end

    def process_geo_fields(item_hash)
      country = item_hash[:categories].delete_at(item_hash[:categories].find_index { |e| /country\// =~ e })
      item_hash[:country] = lookup_country(country.match(/country\/(\w\w)/)[1].upcase)
      item_hash.merge! add_geo_fields([item_hash[:country]])
    end

    def process_urls(item_hash)
      item_hash[:url].gsub!(/www\./, 'mcc.')
      item_hash[:id] = Utils.generate_id(item_hash, %i(url description title id))
      item_hash[:url] = UrlMapper.get_bitly_url(item_hash[:url], model_class) if item_hash[:url].present?
      item_hash
    end

    def lookup_country(country)
      IsoCountryCodes.find(country)
      country
    rescue IsoCountryCodes::UnknownCodeError
      Rails.logger.error "Could not find a country code for #{country}"
      nil
    end
  end
end
