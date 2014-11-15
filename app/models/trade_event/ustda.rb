module TradeEvent
  class Ustda
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'USTDA'
  end
end
