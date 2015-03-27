class Api::V1::CountryCommercialGuidesController < ApiController
  include Searchable
  search_by :q, :countries, :topics, :industries
end
