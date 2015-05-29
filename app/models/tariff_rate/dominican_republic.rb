module TariffRate
  class DominicanRepublic
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'DO',
    }
  end
end
