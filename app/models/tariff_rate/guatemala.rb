module TariffRate
  class Guatemala
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'GT',
    }
  end
end
