module TradeEvent
  class BaseData
    private

    def trade_events(xpath, encoding)
      resource = open(@resource)

      Nokogiri::XML(resource, nil, encoding).xpath(xpath).map { |event_info| process_event_info(event_info) }.compact
    end
  end
end
