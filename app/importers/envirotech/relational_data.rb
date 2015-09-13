module Envirotech
  class RelationalData
    cattr_accessor :relations, :solution_ids_names

    def import
      return unless  RelationalData.relations.present?
      process_regulation_relations
      process_solution_relations
    end

    private

    def process_regulation_relations
      regulations = Envirotech::Consolidated.search_for(sources: 'regulations', size: 100)
      regulations = regulations[:hits].map { |hit| {id: hit[:_id]}.merge(hit[:_source].except(:id))  }

      regulations.each do |article|
        issue_ids = issues_for_regulation(article)
        article[:issue_ids] = issue_ids if issue_ids.present?

        solution_ids = solutions_for_regulation(article)
        article[:solution_ids] = solution_ids if solution_ids.present?
      end

      Envirotech::Regulation.update(regulations)

      issue_documents = issues_with_relations(regulations, :regulation_ids)
      solution_documents = solutions_for_regulations(regulations)
      Envirotech::Issue.update(issue_documents)
      Envirotech::Solution.update(solution_documents)
    end

    def process_solution_relations
      solutions = Envirotech::Consolidated.search_for(sources: 'solutions', size: 100)
      solutions = solutions[:hits].map { |hit| {id: hit[:_id]}.merge(hit[:_source].except(:id))  }

      solutions.each do |article|
        issue_ids = issues_for_solution(article)
        article[:issue_ids] = issue_ids if issue_ids.present?
      end

      Envirotech::Solution.update(solutions)

      issue_documents = issues_with_relations(solutions, :solution_ids)
      Envirotech::Issue.update(issue_documents)
    end

    def issues_with_relations(articles, issue_document_key)
      issue_documents = []
      articles.each do |article|
        next if article[:issue_ids].blank?
        issues = Envirotech::Consolidated.search_for(sources:    'issues',
                                                     source_ids: article[:issue_ids].map(&:inspect).join(','),
                                                     size:       100)
        issue_documents << issues[:hits].map { |hit| { hit[:_id] => article[:source_id] } }
      end
      issue_documents = issue_documents.flatten.reduce({}) { |hash, pairs| pairs.each { |k, v| (hash[k] ||= []) << v }; hash }
      issue_documents.map { |k, v| { id: k, issue_document_key => v } }
    end

    def solutions_for_regulations(regulations)
      solution_documents = []
      regulations.each do |regulation|
        next if regulation[:solution_ids].blank?
        solutions = Envirotech::Consolidated.search_for(sources:    'solutions',
                                                        source_ids: regulation[:solution_ids].map(&:inspect).join(','),
                                                        size:       100)
        solution_documents << solutions[:hits].map { |hit| { hit[:_id] => regulation[:source_id] } }
      end
      solution_documents = solution_documents.flatten.reduce({}) { |hash, pairs| pairs.each { |k, v| (hash[k] ||= []) << v }; hash }
      solution_documents.map { |k, v| { id: k, regulation_ids: v } }
    end

    def issues_for_regulation(regulation)
      issues_documents = Envirotech::Consolidated.search_for(sources: 'issues', size: 100)
      issue_ids_names = issues_documents[:hits].map { |d|  [d[:_source][:source_id], d[:_source][:name_english]] }
      issues_from_relation = RelationalData.relations.select { |_, v| v.with_indifferent_access[:regulations].include?(regulation[:name_english]) }
      issue_ids_names.select {|issue| issues_from_relation.include?(issue.last)}.map(&:first)
    end

    def solutions_for_regulation(regulation)
      related_solutions = RelationalData.relations.select do |_, v|
        v.with_indifferent_access[:regulations].include?(regulation[:name_english])
      end
      related_solutions = related_solutions.map { |_, hash| hash.with_indifferent_access[:solutions] }.flatten

      RelationalData.solution_ids_names.select { |_, name_english| related_solutions.include?(name_english) }.map(&:first)
    end

    def issues_for_solution(solution)
      issues_documents = Envirotech::Consolidated.search_for(sources: 'issues', size: 100)
      issue_ids_names = issues_documents[:hits].map { |d|  [d[:_source][:source_id], d[:_source][:name_english]] }
      issues_from_relation = RelationalData.relations.select { |_, v| v.with_indifferent_access[:solutions].include?(solution[:name_english]) }
      issue_ids_names.select {|issue| issues_from_relation.include?(issue.last)}.map(&:first)
    end

    def RelationalData.relations
      @@relations ||= Envirotech::ToolkitData.fetch_relational_data
    end

    def RelationalData.solution_ids_names
      if @@solution_ids_names.blank?
        solution_documents = Envirotech::Consolidated.search_for(sources: 'solutions', size: 100)
        @@solution_ids_names = solution_documents[:hits].map { |d|  [d[:_source][:source_id], d[:_source][:name_english]] }
      else
        @@solution_ids_names
      end
    end
  end
end
