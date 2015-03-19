module TariffRate
  class Australia
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'AU',
    }
  end
end
