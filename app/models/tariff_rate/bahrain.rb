module TariffRate
  class Bahrain
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'BH',
    }
  end
end
