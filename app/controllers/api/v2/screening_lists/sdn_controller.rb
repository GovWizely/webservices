class Api::V2::ScreeningLists::SdnController < Api::V2Controller
  include Searchable
  search_by :countries, :q, :type
end
