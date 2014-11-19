class Api::V2::ItaOfficeLocationsController < ApplicationController
  include Searchable
  search_by :countries, :state, :city, :q
end
