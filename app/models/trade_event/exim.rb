module TradeEvent
  class Exim
    extend ::Indexable
    include Mappable
    self.source = 'EXIM'
  end
end
