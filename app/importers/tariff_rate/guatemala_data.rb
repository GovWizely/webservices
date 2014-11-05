module TariffRate
  class GuatemalaData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = "#{Rails.root}/data/tariff_rates/guatemala/guatemala.csv"
    self.country_code = 'GT'
  end
end
