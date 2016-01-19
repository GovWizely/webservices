class Api::V2::TradeLeads::ConsolidatedController < Api::V2Controller
  search_by :countries, :industries, :q, :sources, :publish_date, :end_date, :publish_date_amended, :trade_regions, :world_regions
end
