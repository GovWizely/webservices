class Api::V2::MarketResearchesController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
