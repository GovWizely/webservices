class BisnForeignSanctionsEvaderData
  include Importer
  include SDNImporter
  self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/fse/fse.xml'
end
