class Api::V1::ScreeningLists::FseController < ApiController
  include Searchable
  search_by :countries, :q, :type
end
