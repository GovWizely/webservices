module TradeEvent
  class Sba
    extend ::Indexable
    include TradeEvent::Mappable
    self.source = {
      code: 'SBA',
    }
  end
end
