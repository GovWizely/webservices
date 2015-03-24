class Api::V2::TradeEvents::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q, :sources, :start_date, :end_date
end
