class Api::V1::UkTradeLeadsController < ApplicationController
  include Searchable
  search_by :q, :industry
end
