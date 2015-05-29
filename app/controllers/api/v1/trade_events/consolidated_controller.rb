class Api::V1::TradeEvents::ConsolidatedController < ApiController
  search_by :countries, :industry, :q, :sources
end
