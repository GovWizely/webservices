class Api::V2::Envirotech::ConsolidatedController < Api::V2Controller
  search_by :q, :sources, :source_ids, :issue_ids, :provider_ids, :solution_ids, :regulation_ids
end
