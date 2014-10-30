class Api::V1::TariffRates::CostaRicaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
