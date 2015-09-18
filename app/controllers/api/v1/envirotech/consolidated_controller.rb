class Api::V1::Envirotech::ConsolidatedController < ApiController
  search_by :q, :sources, :source_ids, :issue_ids, :provider_ids, :solution_ids, :regulation_ids
end
