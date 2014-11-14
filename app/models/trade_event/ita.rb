module TradeEvent
  class Ita
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'ITA',
    }
  end
end
