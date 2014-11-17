class Api::V2::TariffRates::AustraliaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
