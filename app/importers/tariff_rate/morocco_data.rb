module TariffRate
  class MoroccoData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Morocco_Data.csv'
  end
end
