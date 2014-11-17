class Api::V2::ScreeningLists::PlcController < ApplicationController
  include Searchable
  search_by :countries, :q, :type
end
