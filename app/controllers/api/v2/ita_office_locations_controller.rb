class Api::V2::ItaOfficeLocationsController < ApplicationController
  include Searchable
  search_by :country, :state, :city, :q
end
