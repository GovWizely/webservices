class Api::V2::CanadaLeadsController < ApplicationController
  include Searchable
  search_by :title, :description, :industry, :specific_location, :q
end
