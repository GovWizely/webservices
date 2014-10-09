module ScreeningList
  class SdnData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/sdn.xml'
  end
end
