class Api::V2::TariffRates::ElSalvadorController < ApplicationController
  include Searchable
  search_by :countries, :q
end
