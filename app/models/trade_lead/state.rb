module TradeLead
  class State
    include Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'STATE',
    }
  end
end
