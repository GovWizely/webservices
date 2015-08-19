module TariffRate
  class NicaraguaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Nicaragua_Data.csv'
  end
end
