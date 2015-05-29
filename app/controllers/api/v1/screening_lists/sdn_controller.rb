class Api::V1::ScreeningLists::SdnController < ApiController
  search_by :countries, :q, :type
end
