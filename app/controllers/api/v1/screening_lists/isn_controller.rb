class Api::V1::ScreeningLists::IsnController < ApiController
  search_by :countries, :q
end
