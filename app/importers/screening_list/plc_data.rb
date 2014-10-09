module ScreeningList
  class PlcData
    include ::Importer
    include TreasuryListImporter
    self.default_endpoint =
      'http://www.treasury.gov/resource-center/sanctions/Terrorism-Proliferation-Narcotics/Documents/ns_plc.xml'
  end
end
