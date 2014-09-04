class Api::V1::AustralianTradeLeadsController < ApplicationController
  include Searchable
  search_by :q
end
