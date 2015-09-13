module Envirotech
  class RelationalData

    def import
      return unless  Envirotech::Relationships.relational_data.present?
      process_regulation_relations
      process_solution_relations
    end

    def process_regulation_relations
      regulations = Envirotech::Consolidated.search_for(sources: 'regulations', size: 100)
      regulations = regulations[:hits].map { |hit| {id: hit[:_id]}.merge(hit[:_source].except(:id))  }

      if Envirotech::Relationships.relational_data.present?
        regulations.each do |article|
          issue_ids = Envirotech::Relationships.new.issues_for_regulation(article)
          article[:issue_ids] = issue_ids if issue_ids.present?

          solution_ids = Envirotech::Relationships.new.solutions_for_regulation(article)
          article[:solution_ids] = solution_ids if solution_ids.present?
        end
      end

      Envirotech::Regulation.update(regulations)
      # regulations = regulations.except(:id)

      issue_documents = Envirotech::Relationships.new.issues_with_relations(regulations, :regulation_ids)
      solution_documents = Envirotech::Relationships.new.solutions_for_regulations(regulations)
      Envirotech::Issue.update(issue_documents)
      Envirotech::Solution.update(solution_documents)
    end

    def process_solution_relations
      solutions = Envirotech::Consolidated.search_for(sources: 'solutions', size: 100)
      solutions = solutions[:hits].map { |hit| {id: hit[:_id]}.merge(hit[:_source].except(:id))  }

      if Envirotech::Relationships.relational_data.present?
        solutions.each do |article|
          issue_ids = Envirotech::Relationships.new.issues_for_solution(article)
          article[:issue_ids] = issue_ids if issue_ids.present?
        end
      end

      Envirotech::Solution.update(solutions)
      # solutions = solutions.except(:id)

      issue_documents = Envirotech::Relationships.new.issues_with_relations(solutions, :solution_ids)
      Envirotech::Issue.update(issue_documents)
    end
  end
end
