module TradeEvent
  class Ustda
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'USTDA',
    }
  end
end
