module TariffRate
  class CostaRica
    extend ::Indexable
    include TariffRate::Mappable
    self.source = 'COSTA_RICA'
  end
end
