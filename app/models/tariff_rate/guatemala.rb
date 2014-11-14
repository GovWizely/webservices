module TariffRate
  class Guatemala
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'GUATEMALA',
    }
  end
end
