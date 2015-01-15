module TariffRate
  class SouthKoreaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Korea_Data.csv'
    self.country_code = 'KR'
  end
end
