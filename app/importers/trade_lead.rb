module TradeLead
  include CanImportAllSources
  def self.importers
    [TradeLead::FbopenImporter::FullData,
     TradeLead::AustraliaData,
     TradeLead::CanadaData,
     TradeLead::StateData,
     TradeLead::UkData,
     TradeLead::McaData,
     TradeLead::UstdaData]
  end
end
