class Api::V2::TradeEvents::EximController < ApplicationController
  include Searchable
  search_by :q
end
