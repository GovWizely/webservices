class OfacSpecialDesignatedNationalData
  include Importer
  include SDNImporter
  self.model = OfacSpecialDesignatedNational
  self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/sdn.xml'
end
