class Api::V1::TradeEventsController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
