module TariffRate
  class ElSalvador
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'EL_SALVADOR',
    }
  end
end
