module TariffRate
  class SingaporeData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Singapore_Data.csv'
  end
end
