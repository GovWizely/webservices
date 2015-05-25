module TariffRate
  class Chile
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CL',
    }
  end
end
