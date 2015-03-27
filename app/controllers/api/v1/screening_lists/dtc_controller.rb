class Api::V1::ScreeningLists::DtcController < ApiController
  include Searchable
  search_by :q
end
