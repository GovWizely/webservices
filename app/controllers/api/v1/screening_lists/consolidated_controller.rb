class Api::V1::ScreeningLists::ConsolidatedController < ApiController
  include Searchable
  search_by :countries, :q, :type, :sources, :name, :distance, :address, :phonetics
end
