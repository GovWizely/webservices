class Api::V2::Envirotech::ConsolidatedController < ApiController
  search_by :q, :sources, :source_ids
end
