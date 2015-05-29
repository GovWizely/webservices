class Api::V1::TradeEvents::DlController < ApiController
  search_by :countries, :industry, :q
end
