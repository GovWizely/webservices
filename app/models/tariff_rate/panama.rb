module TariffRate
  class Panama
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'PA',
    }
  end
end
