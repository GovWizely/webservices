module Envirotech
  include CanImportAllSources

  def self.import_all_sources
    Envirotech::IssueData.new.import
    Envirotech::BackgroundLinkData.new.import
    Envirotech::AnalysisLinkData.new.import
    Envirotech::ProviderData.new.import

    relational_data = Envirotech::ToolkitData.fetch_relational_data

    Envirotech::RegulationData.new(relation_data: relational_data).import
    Envirotech::SolutionData.new(relation_data: relational_data).import
    Envirotech::ProviderSolutionData.new.import
    true
  end
end
