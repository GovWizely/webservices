module TradeEvent
  class Ita
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'ITA'
  end
end
