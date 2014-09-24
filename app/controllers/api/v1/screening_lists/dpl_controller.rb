class Api::V1::ScreeningLists::DplController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
