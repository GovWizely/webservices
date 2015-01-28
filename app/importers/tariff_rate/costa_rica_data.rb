module TariffRate
  class CostaRicaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Costa_Rica_Data.csv'
    self.country_code = 'CR'
  end
end
