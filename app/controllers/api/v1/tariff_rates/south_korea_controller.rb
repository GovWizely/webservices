class Api::V1::TariffRates::SouthKoreaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
