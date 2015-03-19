module TariffRate
  class Consolidated
    extend ::Consolidated
    self.query_class   = TariffRate::Query
    self.model_classes = [TariffRate::Australia,
                          TariffRate::Bahrain,
                          TariffRate::Chile,
                          TariffRate::Colombia,
                          TariffRate::CostaRica,
                          TariffRate::DominicanRepublic,
                          TariffRate::ElSalvador,
                          TariffRate::Guatemala,
                          TariffRate::Honduras,
                          TariffRate::Morocco,
                          TariffRate::Nicaragua,
                          TariffRate::Oman,
                          TariffRate::Panama,
                          TariffRate::Peru,
                          TariffRate::Singapore,
                          TariffRate::SouthKorea]
  end
end
