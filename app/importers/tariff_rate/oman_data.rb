module TariffRate
  class OmanData
    include ::Importer
    include TariffRate::Importer

    self.default_endpoint = 'FTA_Oman_Data.csv'
  end
end
