module TradeLead
  def self.importers
    [TradeLead::FbopenImporter::FullData,
     TradeLead::CanadaData,
     TradeLead::StateData,
     TradeLead::UkData,
     TradeLead::McaData]
  end
end
