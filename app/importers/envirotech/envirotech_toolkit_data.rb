module Envirotech
  class EnvirotechToolkitData

    def import
      Envirotech::IssueData.new.import
      Envirotech::BackgroundLinkData.new.import
      Envirotech::AnalysisLinkData.new.import
      Envirotech::ProviderData.new.import

      scraper_data = Envirotech::ToolkitScraper.new.all_issue_info
      if scraper_data.blank?
        Airbrake.notify(EnvirotechToolkitNotFound.new)
        Envirotech::RegulationData.new.import
        Envirotech::SolutionData.new.import
      else
        Envirotech::RegulationData.new(scraper_data).import
        Envirotech::SolutionData.new(scraper_data).import
      end

      Envirotech::ProviderSolutionData.new.import
    end
  end
end
