class Api::V1::ScreeningLists::ElController < ApplicationController
  include Searchable
  search_by :countries, :q
end
