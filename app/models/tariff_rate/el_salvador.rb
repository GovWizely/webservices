module TariffRate
  class ElSalvador
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'SV',
    }
  end
end
