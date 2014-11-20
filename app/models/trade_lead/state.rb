module TradeLead
  class State
    extend ::Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'STATE',
    }
  end
end
