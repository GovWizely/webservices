class BisnForeignSanctionsEvaderData
  include Importer
  include SDNImporter
  self.model = BisnForeignSanctionsEvader
  self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/fse/fse.xml'
end
