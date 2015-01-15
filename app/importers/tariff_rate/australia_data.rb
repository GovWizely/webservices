module TariffRate
  class AustraliaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Australia_Data.csv'
    self.country_code = 'AU'
  end
end
