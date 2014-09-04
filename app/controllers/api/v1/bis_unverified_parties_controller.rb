class Api::V1::BisUnverifiedPartiesController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
