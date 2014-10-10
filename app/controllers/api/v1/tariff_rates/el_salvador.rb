class Api::V1::TariffRates::ElSalvadorController < ApplicationController
  include Searchable
  search_by :countries, :q
end
