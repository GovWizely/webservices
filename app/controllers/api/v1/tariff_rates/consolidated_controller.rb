class Api::V1::TariffRates::ConsolidatedController < ApiController
  include Searchable
  search_by :q, :sources
end
