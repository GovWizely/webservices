module TradeEvent
  class Ustda
    include Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'USTDA',
    }
  end
end
