class Api::V1::ScreeningLists::UvlController < ApiController
  include Searchable
  search_by :countries, :q
end
