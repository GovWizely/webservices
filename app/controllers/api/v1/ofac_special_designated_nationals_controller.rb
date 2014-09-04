class Api::V1::OfacSpecialDesignatedNationalsController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
