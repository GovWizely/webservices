class Api::V1::TradeLeads::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :industries, :q, :sources
end
