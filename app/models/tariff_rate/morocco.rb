module TariffRate
  class Morocco
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'MA',
    }
  end
end
