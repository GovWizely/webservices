class Api::V1::MarketResearchesController < ApiController
  include Searchable
  search_by :countries, :industry, :q
end
