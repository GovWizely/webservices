class Api::V1::ScreeningLists::FseController < ApiController
  search_by :countries, :q, :type
end
