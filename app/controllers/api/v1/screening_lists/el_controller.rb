class Api::V1::ScreeningLists::ElController < ApiController
  search_by :countries, :q
end
