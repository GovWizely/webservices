class Api::V1::StateTradeLeadsController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q, :specific_location
end
