class Api::V2::TariffRates::ConsolidatedController < ApplicationController
  include Searchable
  search_by :q, :sources
end
