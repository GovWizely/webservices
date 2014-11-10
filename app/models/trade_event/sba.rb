module TradeEvent
  class Sba
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = 'SBA'
  end
end
