require 'open-uri'

module TradeEvent
  class EximData
    include Importer

    attr_accessor :reject_if_ends_before

    ENDPOINT = 'http://www.exim.gov/customcf/feeds/events/'
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'

    XPATHS = {
      id:                './id',
      event_name:        './event_name',
      start_date:        './start_date',
      end_date:          './end_date',
      registration_link: './registration_link',
      description:       './description',
      url:               './url',
      city:              './city',
      state:             './state',
    }.freeze

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      doc = Nokogiri::XML(open(ENDPOINT, 'User-Agent' => USER_AGENT))
      trade_events = doc.xpath('//item').map do |event_info|
        trade_event = process_event_info(event_info)
        trade_event
      end.compact
      Exim.index trade_events
    end

    private

    def process_event_info(event_info)
      event_hash = extract_fields(event_info, XPATHS)
      event_hash[:description] = Sanitize.clean(event_hash[:description], whitespace_elements: {})
      event_hash[:start_date] = parse_american_date(event_hash[:start_date])
      event_hash[:end_date] = event_hash[:end_date].present? ? parse_american_date(event_hash[:end_date]) : event_hash[:start_date]
      event_hash[:country] = nil
      event_hash[:industries] = []
      event_hash[:source] = self.class.model_class.source
      event_hash
    end
  end
end
