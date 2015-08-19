module TariffRate
  class SouthKoreaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Korea_Data.csv'
  end
end
