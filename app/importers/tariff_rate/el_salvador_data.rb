module TariffRate
  class ElSalvadorData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/el_salvador/el_salvador.csv"
    self.country_code = 'SV'
  end
end
