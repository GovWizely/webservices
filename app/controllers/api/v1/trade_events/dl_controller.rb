class Api::V1::TradeEvents::DlController < ApiController
  include Searchable
  search_by :countries, :industry, :q
end
