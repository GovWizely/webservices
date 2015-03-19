module TariffRate
  class Chile
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'CL',
    }
  end
end
