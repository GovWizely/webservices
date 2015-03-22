class Api::V2::TradeEvents::SbaController < ApplicationController
  include Searchable
  search_by :countries, :industries, :q
end
