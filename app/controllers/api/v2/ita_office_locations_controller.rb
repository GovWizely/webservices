class Api::V2::ItaOfficeLocationsController < Api::V2Controller
  include Searchable
  search_by :countries, :state, :city, :q
end
