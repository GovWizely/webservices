class Api::V1::TradeEvents::UstdaController < ApiController
  search_by :countries, :industry, :q
end
