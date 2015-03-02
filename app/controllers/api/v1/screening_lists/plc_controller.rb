class Api::V1::ScreeningLists::PlcController < ApiController
  include Searchable
  search_by :countries, :q, :type
end
