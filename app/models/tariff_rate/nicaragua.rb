module TariffRate
  class Nicaragua
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'NI',
    }
  end
end
