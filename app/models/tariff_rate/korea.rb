module TariffRate
  class Korea
    extend ::Indexable
    include TariffRate::Mappable
    self.source = 'KOREA'
  end
end
