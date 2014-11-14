module TariffRate
  class Australia
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'AUSTRALIA',
    }
  end
end
