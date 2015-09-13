module Envirotech
  include CanImportAllSources

  def self.import_all_sources
    Envirotech::ImportWorker.perform_async
  end

  def self.import_sequentially
    Envirotech::IssueData.new.import
    Envirotech::SolutionData.new.import
    Envirotech::RegulationData.new.import
    Envirotech::ProviderData.new.import
    Envirotech::AnalysisLinkData.new.import
    Envirotech::BackgroundLinkData.new.import
    Envirotech::ProviderSolutionData.new.import
    Envirotech::RelationalData.new.import
    true
  end
end
