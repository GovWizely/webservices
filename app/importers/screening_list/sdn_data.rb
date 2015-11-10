module ScreeningList
  class SdnData
    include Importable
    include VersionableResource
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
    include ScreeningList::MakeAddressVariants
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/sdn.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/default.aspx'
    self.program_id = 'SDN'
  end
end
