module TariffRate
  class SouthKorea
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'KR',
    }
  end
end
