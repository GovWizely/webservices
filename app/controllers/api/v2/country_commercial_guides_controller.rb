class Api::V2::CountryCommercialGuidesController < ApplicationController
  include Searchable
  search_by :q, :countries, :topics, :industries
end
