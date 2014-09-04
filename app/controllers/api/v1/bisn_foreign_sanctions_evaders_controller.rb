class Api::V1::BisnForeignSanctionsEvadersController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type
end
