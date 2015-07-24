class Api::V2::Envirotech::ConsolidatedController < ApiController
  search_by :q, :sources, :source_ids, :issue_ids, :provider_ids, :solution_ids
end
