module ScreeningList
  class SdnData
    include ::Importer
    prepend ::Importer::DeletesOldDocuments
    include ScreeningList::TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/sdn.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/default.aspx'
  end
end
