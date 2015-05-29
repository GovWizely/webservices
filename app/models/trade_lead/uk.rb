module TradeLead
  class Uk
    include Indexable
    include TradeLead::Mappable

    self.source = {
      code: 'UK',
    }
  end
end
