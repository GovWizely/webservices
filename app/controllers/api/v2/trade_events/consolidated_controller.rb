class Api::V2::TradeEvents::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :industries, :q, :sources
end
