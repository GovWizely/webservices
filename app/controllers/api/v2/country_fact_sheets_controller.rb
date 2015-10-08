class Api::V2::CountryFactSheetsController < Api::V2Controller
  include Searchable
  search_by :q, :countries, :sources, :topics
end
