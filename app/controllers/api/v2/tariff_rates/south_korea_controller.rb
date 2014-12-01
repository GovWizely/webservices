class Api::V2::TariffRates::SouthKoreaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
