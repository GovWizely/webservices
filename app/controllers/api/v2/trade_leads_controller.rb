class Api::V2::TradeLeadsController < ApplicationController
  include Searchable
  search_by :countries, :q
end
