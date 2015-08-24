module TariffRate
  class AustraliaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Australia_Data.csv'
  end
end
