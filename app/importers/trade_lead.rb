module TradeLead
  include CanImportAllSources
  def self.importers
    [TradeLead::FbopenImporter::FullData,
     TradeLead::CanadaData,
     TradeLead::StateData,
     TradeLead::UkData,
     TradeLead::McaData]
  end
end
