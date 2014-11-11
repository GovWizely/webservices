class Api::V2::ScreeningLists::FseController < ApplicationController
  include Searchable
  search_by :countries, :q, :type
end
