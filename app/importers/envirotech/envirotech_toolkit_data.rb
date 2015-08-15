module Envirotech
  class EnvirotechToolkitData

    def import
      Envirotech::IssueData.new.import
      Envirotech::BackgroundLinkData.new.import
      Envirotech::AnalysisLinkData.new.import
      Envirotech::ProviderData.new.import
      Envirotech::RegulationData.new.import
      Envirotech::SolutionData.new.import
      Envirotech::ProviderSolutionData.new.import
    end
  end
end
