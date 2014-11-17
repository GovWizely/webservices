class Api::V2::TradeEvents::UstdaController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
