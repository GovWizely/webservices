class Api::V1::ItaTradeEventsController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
