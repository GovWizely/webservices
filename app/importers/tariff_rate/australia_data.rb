module TariffRate
  class AustraliaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/australia/australia.csv"
    self.country_code = 'AU'
  end
end
