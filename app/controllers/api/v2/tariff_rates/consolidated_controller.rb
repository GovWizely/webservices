class Api::V2::TariffRates::ConsolidatedController < ApplicationController
  include Searchable
  search_by :q, :sources, :final_year, :partner_start_year, :reporter_start_year
end
