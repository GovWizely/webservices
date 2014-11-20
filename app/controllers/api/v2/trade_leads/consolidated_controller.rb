class Api::V2::TradeLeads::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :industries, :q, :sources
end
