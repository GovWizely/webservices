class Api::V1::TariffRates::GuatemalaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
