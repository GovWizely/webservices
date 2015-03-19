module TariffRate
  class HondurasData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Honduras_Data.csv'
  end
end
