module TariffRate
  class GuatemalaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Guatemala_Data.csv'
    self.country_code = 'GT'
  end
end
