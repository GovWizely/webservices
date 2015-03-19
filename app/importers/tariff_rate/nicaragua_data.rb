module TariffRate
  class NicaraguaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Nicaragua_Data.csv'
  end
end
