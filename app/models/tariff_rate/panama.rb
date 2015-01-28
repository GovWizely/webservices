module TariffRate
  class Panama
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'PA',
    }
  end
end
