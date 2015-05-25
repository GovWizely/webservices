class Api::V1::ScreeningLists::SsiController < ApiController
  search_by :countries, :q, :type
end
