class Api::V1::ConsolidatedScreeningEntriesController < ApplicationController
  include Searchable
  search_by :countries, :q, :sdn_type, :sources
end
