module ScreeningList
  class SsiData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/ssi/ssi.xml'
  end
end
