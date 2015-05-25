module TariffRate
  class CostaRica
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CR',
    }
  end
end
