module ScreeningList
  class IsaData
    include Importable
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
    self.default_endpoint =
      'http://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/programs/pages/iran.aspx#isa'
    self.program_id = 'NS-ISA'
  end
end
