class Api::V2::ScreeningLists::DplController < ApplicationController
  include Searchable
  search_by :countries, :q
end
