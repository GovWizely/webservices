module TradeEvent
  class Consolidated
    include Findable
    include Searchable
    self.model_classes = [TradeEvent::Ita,
                          TradeEvent::Sba,
                          # TradeEvent::Exim,
                          TradeEvent::Ustda,
                          TradeEvent::Dl,]
  end
end
