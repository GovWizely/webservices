module TariffRate
  class MoroccoData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Morocco_Data.csv'
  end
end
