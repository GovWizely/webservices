module ScreeningList
  class FseData < Base
    self.default_endpoint = 'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/fse_list.aspx'
    self.program_id = 'FSE-'
  end
end
