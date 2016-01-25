module ScreeningList
  class SdnData < Base
    self.default_endpoint = 'https://www.treasury.gov/ofac/downloads/sdn.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/SDN-List/Pages/default.aspx'
    self.program_id = 'SDN'
  end
end
