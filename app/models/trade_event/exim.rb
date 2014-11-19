module TradeEvent
  class Exim
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'EXIM',
    }
  end
end
