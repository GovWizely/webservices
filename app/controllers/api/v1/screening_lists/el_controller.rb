class Api::V1::ScreeningLists::ElController < ApiController
  include Searchable
  search_by :countries, :q
end
