class Api::V1::ItaOfficeLocationsController < ApplicationController
  include Searchable
  search_by :country, :state, :city, :q
end
