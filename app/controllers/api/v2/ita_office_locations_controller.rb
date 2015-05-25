class Api::V2::ItaOfficeLocationsController < Api::V2Controller
  search_by :countries, :state, :city, :q
end
