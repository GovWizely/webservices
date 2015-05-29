module TradeEvent
  class Exim
    include Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'EXIM',
    }
  end
end
