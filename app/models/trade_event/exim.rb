module TradeEvent
  class Exim
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'EXIM'
  end
end
