module TradeEvent
  class Dl
    include Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'DL',
    }
  end
end
