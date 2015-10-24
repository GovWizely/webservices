module Envirotech
  class ToolkitData
    RELATION_DATA = "#{Rails.root}/data/envirotech/issue_solution_regulation.json"

    # This solution is valid until we have full control over the toolkit.
    def self.fetch_relational_data
      local = JSON.parse(open(RELATION_DATA).read)

      scraped = Envirotech::ToolkitScraper.new.all_issue_info rescue {}

      if scraped.blank?
        Airbrake.notify(Exceptions::EnvirotechToolkitNotFound.new)
      elsif scraped != local
        Airbrake.notify(Exceptions::EnvirotechToolkitDataMismatch.new)
      end

      scraped.present? ? scraped : local
    end
  end
end
