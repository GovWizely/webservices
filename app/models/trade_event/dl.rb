module TradeEvent
  class Dl
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'DL'
  end
end
