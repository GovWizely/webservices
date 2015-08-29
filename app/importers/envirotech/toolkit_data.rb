module Envirotech
  class ToolkitData
    RELATION_DATA = "#{Rails.root}/data/envirotech/issue_solution_regulation.json"

    # This solution is valid until we have full control over the toolkit.
    def self.fetch_relational_data
      local = JSON.parse(open(RELATION_DATA).read).deep_symbolize_keys
      scraped = Envirotech::ToolkitScraper.new.all_issue_info

      if scraped.blank?
        Airbrake.notify(Exceptions::EnvirotechToolkitNotFound.new)
      elsif scraped != local
        Airbrake.notify(Exceptions::EnvirotechToolkitDataMismatch.new)
      end

      scraped || local
    end

    def self.process_issue_relations(articles, issue_document_key)
      issue_documents = []
      articles.each do |article|
        next if article[:issue_ids].blank?
        issues = Envirotech::Consolidated.search_for(sources: 'issues',
                                                     source_ids: article[:issue_ids].map(&:inspect).join(','),
                                                     size: 100)
        issue_documents << issues[:hits].map { |hit| { hit[:_id] => article[:source_id] } }
      end
      issue_documents = issue_documents.flatten.reduce({}) { |hash, pairs| pairs.each { |k, v| (hash[k] ||= []) << v }; hash }
      issue_documents.map { |k,v| { id: k, issue_document_key => v } }
    end
  end
end
