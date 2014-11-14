require 'open-uri'

module TradeEvent
  class DlData
    include ::Importer

    attr_accessor :reject_if_ends_before

    ENDPOINT = 'http://www.state.gov/rss/channels/dl.xml'

    XPATHS = {
      event_name:  './title',
      description: './description',
      url:         './link',
    }.freeze

    def initialize(resource = ENDPOINT, options = {})
      @resource = resource
      self.reject_if_ends_before = options.fetch(:reject_if_ends_before, Date.current)
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      doc = Nokogiri::XML(open(@resource))
      trade_events = doc.xpath('//item').map do |event_info|
        process_event_info(event_info)
      end.compact
      Dl.index(trade_events)
    end

    private

    def process_event_info(event_info)
      event_hash = extract_fields(event_info, XPATHS)
      event_hash[:source] = model_class.source[:code]
      event_hash[:id] = generate_id(event_hash)
      sanitize_entry(event_hash)
    end

    def generate_id(event_hash)
      Digest::SHA1.hexdigest(
        %i(event_name description url id).map { |f| event_hash[f] }.join)
    end
  end
end
