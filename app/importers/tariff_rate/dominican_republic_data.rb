module TariffRate
  class DominicanRepublicData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Dominican_Republic_Data.csv'
  end
end
