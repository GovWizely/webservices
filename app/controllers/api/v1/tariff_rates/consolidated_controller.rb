class Api::V1::TariffRates::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :q, :sources
end
