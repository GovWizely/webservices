class Api::V2::AustralianTradeLeadsController < ApplicationController
  include Searchable
  search_by :q
end
