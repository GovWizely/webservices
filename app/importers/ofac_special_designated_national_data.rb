class OfacSpecialDesignatedNationalData
  include Importer
  include SDNImporter
  self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/sdn.xml'
end
