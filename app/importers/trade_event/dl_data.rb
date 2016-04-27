require 'open-uri'

module TradeEvent
  class DlData < BaseData
    include Importable
    include VersionableResource

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
      Dl.index(trade_events('//item', 'ISO-8859-1'))
    end

    private

    def process_event_info(event_info)
      event_hash = extract_fields(event_info, XPATHS)
      event_hash[:source] = model_class.source[:code]
      event_hash[:id] = Utils.generate_id(event_hash, %i(event_name description url id))
      event_hash
      sanitize_entry(event_hash)
    end
  end
end
