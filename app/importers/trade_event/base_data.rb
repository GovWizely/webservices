module TradeEvent
  class BaseData
    private

    def trade_events(xpath)
      Nokogiri::XML(loaded_resource).xpath(xpath).map { |event_info| process_event_info(event_info) }.compact
    end
  end
end
