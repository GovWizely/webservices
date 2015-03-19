module TariffRate
  class ElSalvador
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'SV',
    }
  end
end
