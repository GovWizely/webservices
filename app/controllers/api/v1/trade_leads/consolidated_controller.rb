class Api::V1::TradeLeads::ConsolidatedController < ApiController
  include Searchable
  search_by :countries, :industries, :q, :sources
end
