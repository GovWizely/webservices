module TariffRate
  class ChileData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Chile_Data.csv'
  end
end
