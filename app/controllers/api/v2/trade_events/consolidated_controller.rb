class Api::V2::TradeEvents::ConsolidatedController < Api::V2Controller
  include Searchable
  search_by :countries, :industries, :q, :sources
end
