class Api::V2::ScreeningLists::SsiController < ApplicationController
  include Searchable
  search_by :countries, :q, :type
end
