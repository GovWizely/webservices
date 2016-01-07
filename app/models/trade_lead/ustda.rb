module TradeLead
  class Ustda
    include Indexable
    include TradeLead::Mappable

    self.source = {
      code: 'USTDA',
    }
  end
end
