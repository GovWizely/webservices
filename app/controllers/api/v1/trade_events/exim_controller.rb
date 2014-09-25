class Api::V1::TradeEvents::EximController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
