class Api::V2::TariffRates::GuatemalaController < ApplicationController
  include Searchable
  search_by :countries, :q
end
