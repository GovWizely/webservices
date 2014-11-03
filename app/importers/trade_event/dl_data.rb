require 'open-uri'

module TradeEvent
  class DlData
    include ::Importer

    attr_accessor :reject_if_ends_before

    ENDPOINT = 'http://www.state.gov/rss/channels/dl.xml'
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'

    XPATHS = {
      event_name:        './title',
      description:       './description',
      url:               './link',
      start_date:        './start_date',
      end_date:          './end_date'
    }.freeze

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      doc = Nokogiri::XML(resource_fh)
      trade_events = doc.xpath('//item').map do |event_info|
        trade_event = process_event_info(event_info)
        trade_event
      end.compact
      Dl.index trade_events
    end

    private

    def resource_fh
      if URI.parse(@resource).scheme =~ /ftp|http/
        return open(@resource, 'User-Agent' => USER_AGENT)
      end
      open(@resource, 'r:UTF-8')
    end

    def process_event_info(event_info)
      event_hash = extract_fields(event_info, XPATHS)
      event_hash[:city] = nil
      event_hash[:start_date] = parse_american_date( event_hash[:start_date] ) || '2100-01-01'
      event_hash[:end_date] = parse_american_date( event_hash[:end_date] ) || parse_american_date( event_hash[:start_date] ) || '2100-01-10'
      event_hash[:state] = nil
      event_hash[:country] = nil
      event_hash[:industries] = []
      event_hash[:source] = model_class.source
      sanitize_entry(event_hash)
    end
  end
end
