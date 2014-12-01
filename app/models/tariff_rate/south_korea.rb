module TariffRate
  class SouthKorea
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'SOUTH_KOREA',
    }
  end
end
