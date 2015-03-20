class Api::V2::TradeEvents::EximController < Api::V2Controller
  include Searchable
  search_by :q
end
