class Api::V1::TradeEvents::SbaController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
