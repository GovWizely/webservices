class Api::V2::ScreeningLists::ConsolidatedController < ApplicationController
  include Searchable
  search_by :countries, :q, :type, :sources, :name, :fuzziness, :address
end
