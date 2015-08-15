module Envirotech
  class EnvirotechToolkitData

    def import
      Envirotech::IssueData.new.import
      Envirotech::BackgroundLinkData.new.import
      Envirotech::AnalysisLinkData.new.import
      Envirotech::ProviderData.new.import

      scraper_data = Envirotech::ToolkitScraper.new.all_issue_info

      Envirotech::RegulationData.new(scraper_data).import
      Envirotech::SolutionData.new(scraper_data).import
      Envirotech::ProviderSolutionData.new.import
    end
  end
end
