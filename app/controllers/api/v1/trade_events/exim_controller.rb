class Api::V1::TradeEvents::EximController < ApiController
  search_by :countries, :industry, :q
end
