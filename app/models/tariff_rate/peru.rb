module TariffRate
  class Peru
    extend ::Indexable
    include TariffRate::Mappable
    self.source = {
      code: 'PE',
    }
  end
end
