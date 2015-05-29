class Api::V2::MarketResearchesController < Api::V2Controller
  search_by :countries, :industries, :q, :expiration_date
end
