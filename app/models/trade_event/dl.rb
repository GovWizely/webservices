module TradeEvent
  class Dl
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'DL',
    }
  end
end
