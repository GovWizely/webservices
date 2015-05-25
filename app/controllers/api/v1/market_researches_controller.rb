class Api::V1::MarketResearchesController < ApiController
  search_by :countries, :industry, :q
end
