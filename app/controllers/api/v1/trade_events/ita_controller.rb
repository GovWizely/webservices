class Api::V1::TradeEvents::ItaController < ApiController
  include Searchable
  search_by :countries, :industry, :q
end
