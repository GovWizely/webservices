class Api::V1::TradeLeads::ConsolidatedController < ApiController
  search_by :countries, :industries, :q, :sources
end
