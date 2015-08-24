module TariffRate
  class HondurasData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Honduras_Data.csv'
  end
end
