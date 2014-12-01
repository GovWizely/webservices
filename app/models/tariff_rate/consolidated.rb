module TariffRate
  class Consolidated
    extend ::Consolidated
    self.query_class   = TariffRate::Query
    self.model_classes = [TariffRate::Australia,
                          TariffRate::CostaRica,
                          TariffRate::ElSalvador,
                          TariffRate::Guatemala,
                          TariffRate::SouthKorea]
  end
end
