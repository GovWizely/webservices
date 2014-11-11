class Api::V2::ScreeningLists::UvlController < ApplicationController
  include Searchable
  search_by :countries, :q
end
