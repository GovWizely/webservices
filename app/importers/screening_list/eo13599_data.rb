module ScreeningList
  class Eo13599Data < Base
    self.default_endpoint =
      'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/Programs/Pages/13599_list.aspx'
    self.program_id = 'IRAN'
  end
end
