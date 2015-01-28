module TariffRate
  class Honduras
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'HN',
    }
  end
end
