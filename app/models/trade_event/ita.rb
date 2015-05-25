module TradeEvent
  class Ita
    include Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'ITA',
    }
  end
end
