module ScreeningList
  class FseData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/fse/fse.xml'
  end
end
