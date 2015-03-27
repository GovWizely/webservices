class Api::V2::TradeEvents::UstdaController < Api::V2Controller
  include Searchable
  search_by :countries, :industries, :q
end
