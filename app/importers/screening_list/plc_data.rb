module ScreeningList
  class PlcData < Base
    self.default_endpoint =
      'https://www.treasury.gov/ofac/downloads/consolidated/consolidated.xml'
    self.source_information_url =
      'https://www.treasury.gov/resource-center/sanctions/Programs/Pages/pa.aspx'
    self.program_id = 'NS-PLC'
  end
end
