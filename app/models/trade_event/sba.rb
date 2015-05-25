module TradeEvent
  class Sba
    include Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'SBA',
    }
  end
end
