module TariffRate
  class BahrainData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Bahrain_Data.csv'
  end
end
