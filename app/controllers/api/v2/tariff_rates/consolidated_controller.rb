class Api::V2::TariffRates::ConsolidatedController < Api::V2Controller
  include Searchable
  search_by :q, :sources
end
