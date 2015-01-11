class Api::V1::CountryCommercialGuidesController < ApplicationController
  include Searchable
  search_by :q, :countries, :topics, :industries
end
