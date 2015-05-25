class Api::V1::TradeEvents::ItaController < ApiController
  search_by :countries, :industry, :q
end
