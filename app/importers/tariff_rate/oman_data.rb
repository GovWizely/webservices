module TariffRate
  class OmanData
    include Importable
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Oman_Data.csv'
  end
end
