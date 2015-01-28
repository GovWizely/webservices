module TariffRate
  class CostaRica
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CR',
    }
  end
end
