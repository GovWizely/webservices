class Api::V1::FbopenLeadsController < ApplicationController
  include Searchable
  search_by :title, :description, :industry, :specific_location, :q
end
