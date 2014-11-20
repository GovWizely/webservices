module TradeLead
  class Australia
    extend ::Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'AUSTRALIA',
    }
  end
end
