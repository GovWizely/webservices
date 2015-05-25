class Api::V1::CountryCommercialGuidesController < ApiController
  search_by :q, :countries, :topics, :industries
end
