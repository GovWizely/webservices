class Api::V1::ScreeningLists::PlcController < ApiController
  search_by :countries, :q, :type
end
