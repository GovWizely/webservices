module ScreeningList
  class SsiData
    include Importable
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
    self.default_endpoint = 'http://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/ssi_list.aspx'
    self.program_id = 'UKRAINE-EO13662'
  end
end
