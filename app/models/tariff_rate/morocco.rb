module TariffRate
  class Morocco
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'MA',
    }
  end
end
