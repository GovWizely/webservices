module TariffRate
  class Peru
    include Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'PE',
    }
  end
end
