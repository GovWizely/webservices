module ScreeningList
  class FseData
    include ::Importer
    include SdnImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/fse/fse.xml'
  end
end
