module TariffRate
  class Korea
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'KOREA',
    }
  end
end
