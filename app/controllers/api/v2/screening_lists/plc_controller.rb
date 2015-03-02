class Api::V2::ScreeningLists::PlcController < Api::V2Controller
  include Searchable
  search_by :countries, :q, :type
end
