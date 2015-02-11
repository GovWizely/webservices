class Api::V1::ScreeningLists::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :q, :type, :sources, :name, :fuzziness, :address
end
