module Envirotech
  class ToolkitData
    RELATION_DATA = "#{Rails.root}/data/envirotech/issue_solution_regulation.json"

    def import
      relational_data = fetch_relational_data

      Envirotech::IssueData.new.import
      Envirotech::BackgroundLinkData.new.import
      Envirotech::AnalysisLinkData.new.import
      Envirotech::ProviderData.new.import
      Envirotech::RegulationData.new(relation_data: relational_data).import
      Envirotech::SolutionData.new(relation_data: relational_data).import
      Envirotech::ProviderSolutionData.new.import
    end

    # This solution is valid until we have full control over the toolkit.
    def fetch_relational_data
      local = JSON.parse(open(RELATION_DATA).read).deep_symbolize_keys
      scraped = Envirotech::ToolkitScraper.new.all_issue_info

      if scraped.blank?
        Airbrake.notify(Exceptions::EnvirotechToolkitNotFound.new)
      elsif scraped != local
        Airbrake.notify(Exceptions::EnvirotechToolkitDataMismatch.new)
      end

      scraped || local
    end
  end
end
