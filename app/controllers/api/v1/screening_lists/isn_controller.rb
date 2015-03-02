class Api::V1::ScreeningLists::IsnController < ApiController
  include Searchable
  search_by :countries, :q
end
