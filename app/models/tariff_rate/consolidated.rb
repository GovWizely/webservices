module TariffRate
  class Consolidated
    include Searchable
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
                          TariffRate::SouthKorea,]
  end
end
