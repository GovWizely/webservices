module TariffRate
  class GuatemalaData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Guatemala_Data.csv'
  end
end
