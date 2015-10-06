module TradeEvent
  class Consolidated
    include Searchable
    self.model_classes = [TradeEvent::Ita,
                          TradeEvent::Sba,
                          #TradeEvent::Exim,
                          TradeEvent::Ustda,
                          TradeEvent::Dl]
  end
end
