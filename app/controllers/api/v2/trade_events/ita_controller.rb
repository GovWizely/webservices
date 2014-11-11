class Api::V2::TradeEvents::ItaController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
