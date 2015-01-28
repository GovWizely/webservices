module TariffRate
  class DominicanRepublic
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'DO',
    }
  end
end
