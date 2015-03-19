module TariffRate
  class GuatemalaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Guatemala_Data.csv'
  end
end
