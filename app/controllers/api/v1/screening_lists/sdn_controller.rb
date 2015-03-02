class Api::V1::ScreeningLists::SdnController < ApiController
  include Searchable
  search_by :countries, :q, :type
end
