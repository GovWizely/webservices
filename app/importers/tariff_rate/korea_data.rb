module TariffRate
  class KoreaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/korea/korea.csv"
    self.country_code = 'KR'
  end
end
