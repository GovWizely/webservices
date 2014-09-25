class Api::V1::ScreeningLists::IsnController < ApplicationController
  include Searchable
  search_by :countries, :q
end
