class Api::V2::ScreeningLists::DtcController < Api::V2Controller
  include Searchable
  search_by :q
end
