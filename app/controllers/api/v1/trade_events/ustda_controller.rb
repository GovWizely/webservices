class Api::V1::TradeEvents::UstdaController < ApiController
  include Searchable
  search_by :countries, :industry, :q
end
