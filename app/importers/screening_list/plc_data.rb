module ScreeningList
  class PlcData
    include Importable
    include VersionableResource
    include ScreeningList::TreasuryListImporter
    include ScreeningList::MakeNameVariants
    self.default_endpoint =
      'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/Terrorism-Proliferation-Narcotics/Pages/index.aspx'
    self.program_id = 'NS-PLC'
  end
end
