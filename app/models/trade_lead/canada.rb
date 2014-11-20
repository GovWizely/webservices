module TradeLead
  class Canada
    extend ::Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'CANADA',
    }
  end
end
