module TradeEvent
  class Consolidated
    extend ::Consolidated
    self.query_class   = TradeEvent::Query
    self.model_classes = [TradeEvent::Ita,
                          TradeEvent::Sba,
                          TradeEvent::Exim,
                          TradeEvent::Ustda,
                          TradeEvent::Dl]
  end
end
