class Api::V1::ScreeningLists::ConsolidatedController < ApiController
  include Searchable
  search_by :countries, :q, :type, :sources, :name, :fuzziness, :address
end
