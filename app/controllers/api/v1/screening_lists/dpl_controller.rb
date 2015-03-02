class Api::V1::ScreeningLists::DplController < ApiController
  include Searchable
  search_by :countries, :q
end
