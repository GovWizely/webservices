class Api::V2::UkTradeLeadsController < ApplicationController
  include Searchable
  search_by :q, :industry
end
