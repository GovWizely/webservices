class Api::V1::BisnNonproliferationSanctionsController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
