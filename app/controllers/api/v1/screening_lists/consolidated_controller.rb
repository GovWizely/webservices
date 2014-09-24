class Api::V1::ScreeningLists::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type, :sources
end
