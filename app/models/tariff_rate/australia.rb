module TariffRate
  class Australia
    extend ::Indexable
    include TariffRate::Mappable
    self.source = 'AUSTRALIA'
  end
end
