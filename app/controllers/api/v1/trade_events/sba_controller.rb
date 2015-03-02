class Api::V1::TradeEvents::SbaController < ApiController
  include Searchable
  search_by :countries, :industry, :q
end
