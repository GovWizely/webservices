class Api::V1::TradeLeadsController < ApplicationController
  include Searchable
  search_by :countries, :q
end
