require 'rss'

module TradeLead
  class UstdaData
    include Importable
    include VersionableResource

    ENDPOINT = 'https://www.ustda.gov/api/tradeleads/xml'
    RSS_FEED = 'https://www.ustda.gov/business-opportunities/trade-leads/feed'
    CONTAINS_MAPPER_LOOKUPS = true

    KEYS_HASH = {
      'Title'       => :title,
      'Open Date'   => :publish_date,
      'Close Date'  => :end_date,
      'Description' => :description,
    }

    SINGLE_VALUED_XPATHS = {
      title:        './Title',
      publish_date: './Open-Date',
      end_date:     './Close-Date',
      description:  './Description',
    }.freeze

    def initialize(resource = nil, rss_feed = nil)
      @resource = resource || ENDPOINT
      @rss_feed = rss_feed || RSS_FEED
    end

    def import
      document = Nokogiri::XML(loaded_resource)
      parse_rss
      leads = process_leads(document)
      model_class.index(leads)
    end

    def parse_rss
      feed = RSS::Parser.parse(open(@rss_feed), false)
      @rss_hashes = []
      feed.items.each do |item|
        @rss_hashes.push(title: HTMLEntities.new.decode(item.title), url: item.link)
      end
    end

    def process_leads(leads)
      leads.xpath('//node').map do |lead|
        lead = extract_fields(lead, SINGLE_VALUED_XPATHS)
        lead = set_lead_fields(lead)
        lead[:url] = extract_url(lead)
        (lead[:end_date] && Date.parse(lead[:end_date]) < Date.current) ? nil : lead
      end.compact
    end

    def extract_url(lead)
      url_hash = @rss_hashes.find { |rss| rss[:title] == lead[:title] }
      url_hash ? UrlMapper.get_bitly_url(url_hash[:url], model_class) : nil
    end

    def set_lead_fields(lead)
      lead[:id] = Utils.generate_id(lead, %i(title description))
      lead[:publish_date] = parse_american_date(lead[:publish_date]) if lead[:publish_date]
      lead[:end_date] = parse_american_date(lead[:end_date]) if lead[:end_date]
      lead[:source] = model_class.source[:code]
      lead[:country_name] = get_missing_country(lead[:title])
      lead[:country] = begin
                         lookup_country(lead[:country_name])
                       rescue
                         nil
                       end
      lead.merge! add_related_fields([lead[:country_name]])
      lead
    end
  end
end
