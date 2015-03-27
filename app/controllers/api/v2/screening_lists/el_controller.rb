class Api::V2::ScreeningLists::ElController < Api::V2Controller
  include Searchable
  search_by :countries, :q
end
