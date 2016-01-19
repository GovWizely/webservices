class Api::V2::TradeEvents::ConsolidatedController < Api::V2Controller
  search_by :countries, :industries, :q, :sources, :start_date, :end_date, :trade_regions, :world_regions
end
