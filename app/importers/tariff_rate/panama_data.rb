module TariffRate
  class PanamaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Panama_Data.csv'
  end
end
