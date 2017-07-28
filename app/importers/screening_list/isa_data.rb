module ScreeningList
  class IsaData < Base
    self.default_endpoint =
      'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/programs/pages/iran.aspx#isa'
    self.program_id = 'IRAN'
  end
end
