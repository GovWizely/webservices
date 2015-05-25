class Api::V2::CountryCommercialGuidesController < Api::V2Controller
  search_by :q, :countries, :topics, :industries
end
