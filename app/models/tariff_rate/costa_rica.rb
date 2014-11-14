module TariffRate
  class CostaRica
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'COSTA_RICA',
    }
  end
end
