module TariffRate
  class Honduras
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'HN',
    }
  end
end
