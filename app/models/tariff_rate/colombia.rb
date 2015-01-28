module TariffRate
  class Colombia
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CO',
    }
  end
end
