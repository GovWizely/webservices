module TariffRate
  class Bahrain
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'BH',
    }
  end
end
