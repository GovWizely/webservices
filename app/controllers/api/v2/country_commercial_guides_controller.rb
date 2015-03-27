class Api::V2::CountryCommercialGuidesController < Api::V2Controller
  include Searchable
  search_by :q, :countries, :topics, :industries
end
