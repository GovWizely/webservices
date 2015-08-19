module TariffRate
  class CostaRicaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Costa_Rica_Data.csv'
  end
end
