class Api::V1::TariffRates::KoreaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
