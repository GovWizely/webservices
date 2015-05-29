module TariffRate
  class Australia
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'AU',
    }
  end
end
