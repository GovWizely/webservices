module TariffRate
  class Nicaragua
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'NI',
    }
  end
end
