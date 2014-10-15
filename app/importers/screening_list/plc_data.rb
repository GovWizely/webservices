module ScreeningList
  class PlcData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint =
      'http://www.treasury.gov/resource-center/sanctions/Terrorism-Proliferation-Narcotics/Documents/ns_plc.xml'
    self.source_information_url =
      'http://www.treasury.gov/resource-center/sanctions/Terrorism-Proliferation-Narcotics/Pages/index.aspx'
  end
end
