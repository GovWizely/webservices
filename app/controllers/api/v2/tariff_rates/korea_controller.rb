class Api::V2::TariffRates::KoreaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
