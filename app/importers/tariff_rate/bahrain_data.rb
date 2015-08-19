module TariffRate
  class BahrainData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Bahrain_Data.csv'
  end
end
