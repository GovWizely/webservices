class Api::V2::TradeLeads::ConsolidatedController < Api::V2Controller
  include Searchable
  search_by :countries, :industries, :q, :sources, :publish_date, :end_date, :publish_date_amended
end
