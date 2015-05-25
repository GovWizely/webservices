module TariffRate
  class Singapore
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'SG',
    }
  end
end
