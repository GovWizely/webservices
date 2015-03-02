class Api::V2::ScreeningLists::IsnController < Api::V2Controller
  include Searchable
  search_by :countries, :q
end
