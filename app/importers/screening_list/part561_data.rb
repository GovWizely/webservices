module ScreeningList
  class Part561Data < Base
    self.default_endpoint =
      'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/programs/pages/iran.aspx#part561'
    self.program_id = '561List'
  end
end
