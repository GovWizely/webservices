class Api::V1::ScreeningLists::SsiController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
