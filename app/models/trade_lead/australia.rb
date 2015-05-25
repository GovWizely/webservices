module TradeLead
  class Australia
    include Indexable
    include TradeLead::Mappable
    self.source = {
      code: 'AUSTRALIA',
    }
  end
end
