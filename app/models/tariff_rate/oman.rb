module TariffRate
  class Oman
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'OM',
    }
  end
end
