module TariffRate
  class Guatemala
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'GT',
    }
  end
end
