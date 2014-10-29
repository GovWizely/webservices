module ScreeningList
  class FseData
    include ::Importer
    include ScreeningList::TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/fse/fse.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/fse_list.aspx'
  end
end
