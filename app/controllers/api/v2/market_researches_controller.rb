class Api::V2::MarketResearchesController < Api::V2Controller
  include Searchable
  search_by :countries, :industries, :q, :expiration_date
end
