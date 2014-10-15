module ScreeningList
  class SsiData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/ssi/ssi.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/ssi_list.aspx'
  end
end
