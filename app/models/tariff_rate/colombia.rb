module TariffRate
  class Colombia
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CO',
    }
  end
end
