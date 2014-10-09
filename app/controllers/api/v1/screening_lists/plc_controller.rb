class Api::V1::ScreeningLists::PlcController < ApplicationController
  include Searchable
  search_by :countries, :q, :type
end
