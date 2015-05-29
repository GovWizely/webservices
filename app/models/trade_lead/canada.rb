module TradeLead
  class Canada
    include Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'CANADA',
    }
  end
end
