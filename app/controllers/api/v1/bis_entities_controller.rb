class Api::V1::BisEntitiesController < ApplicationController
  include Searchable
  search_by :countries, :q
end
