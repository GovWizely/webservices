module TariffRate
  class PeruData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Peru_Data.csv'
  end
end
