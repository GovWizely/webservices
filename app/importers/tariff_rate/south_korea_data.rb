module TariffRate
  class SouthKoreaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/south_korea/korea.csv"
    self.country_code = 'KR'
  end
end
