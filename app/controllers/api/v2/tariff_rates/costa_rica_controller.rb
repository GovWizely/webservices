class Api::V2::TariffRates::CostaRicaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
