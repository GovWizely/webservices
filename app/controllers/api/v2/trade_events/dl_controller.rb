class Api::V2::TradeEvents::DlController < Api::V2Controller
  include Searchable
  search_by :q
end
