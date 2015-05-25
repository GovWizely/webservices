module TariffRate
  class Oman
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'OM',
    }
  end
end
