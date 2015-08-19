module TariffRate
  class ColombiaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Colombia_Data.csv'
  end
end
