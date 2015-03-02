class Api::V1::TradeEvents::ConsolidatedController < ApiController
  include Searchable
  search_by :countries, :industry, :q, :sources
end
