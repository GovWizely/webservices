class Api::V2::ScreeningLists::ElController < ApplicationController
  include Searchable
  search_by :countries, :q
end
