class Api::V1::ScreeningLists::SsiController < ApiController
  include Searchable
  search_by :countries, :q, :type
end
