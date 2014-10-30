module TariffRate
  class ElSalvador
    extend ::Indexable
    include TariffRate::Mappable
    self.source = 'EL_SALVADOR'
  end
end
