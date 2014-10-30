module TariffRate
  class CostaRicaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/costa_rica/costa_rica.csv"
    self.country_code = 'CR'
  end
end
