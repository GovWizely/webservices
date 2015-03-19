class Api::V1::TariffRates::ConsolidatedController < ApplicationController
  include Searchable
  search_by :q, :sources
end
