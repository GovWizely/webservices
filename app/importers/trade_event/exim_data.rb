require 'open-uri'

module TradeEvent
  class EximData
    include Importable
    include ::VersionableResource

    self.disabled = true

    attr_accessor :reject_if_ends_before

    ENDPOINT = 'http://www.exim.gov/customcf/feeds/events/'
    USER_AGENT = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2'

    SINGLE_VALUED_XPATHS = {
      id:                './id',
      event_name:        './event_name',
      start_date:        './start_date',
      end_date:          './end_date',
      registration_link: './registration_link',
      description:       './description',
      url:               './url',
    }.freeze

    VENUE_XPATHS = {
      city:  './city',
      state: './state',
    }.freeze

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def import
      doc = Nokogiri::XML(loaded_resource)
      trade_events = doc.xpath('//item').map do |event_info|
        trade_event = process_event_info(event_info)
        trade_event
      end.compact
      Exim.index trade_events
    end

    private

    def loaded_resource
      return @loaded_resource if @loaded_resource
      args = URI.parse(@resource).scheme =~ /ftp|http/ ?
        { 'User-Agent' => USER_AGENT } :
        'r:UTF-8'
      @loaded_resource = open(@resource, args).read
    end

    def process_event_info(event_info)
      event_hash = extract_fields(event_info, SINGLE_VALUED_XPATHS)
      return nil if event_invalid?(event_hash)
      event_hash.merge!(extract_dates(event_hash))
      event_hash[:industries] = []
      event_hash[:venues] = extract_venues(event_info)
      event_hash[:source] = model_class.source[:code]
      sanitize_entry(event_hash)
    end

    def event_invalid?(event_hash)
      URI.parse(event_hash[:registration_link]).host =~ /export.gov$/
    rescue URI::InvalidURIError
      false
    end

    def extract_dates(event_hash)
      start_date = parse_american_date(event_hash[:start_date])
      end_date = event_hash[:end_date].present? ?
        parse_american_date(event_hash[:end_date]) :
        start_date
      { start_date: start_date, end_date: end_date }
    end

    def extract_venues(event_info)
      venue = extract_fields(event_info, VENUE_XPATHS)
      venue[:country] = venue[:venue] = nil
      [venue]
    end
  end
end
