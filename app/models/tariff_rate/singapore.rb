module TariffRate
  class Singapore
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'SG',
    }
  end
end
