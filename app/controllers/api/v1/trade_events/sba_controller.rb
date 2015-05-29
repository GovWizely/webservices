class Api::V1::TradeEvents::SbaController < ApiController
  search_by :countries, :industry, :q
end
