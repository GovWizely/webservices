module TariffRate
  class SouthKorea
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'KR',
    }
  end
end
