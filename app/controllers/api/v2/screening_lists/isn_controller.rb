class Api::V2::ScreeningLists::IsnController < ApplicationController
  include Searchable
  search_by :countries, :q
end
