class Api::V1::ScreeningLists::UvlController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end