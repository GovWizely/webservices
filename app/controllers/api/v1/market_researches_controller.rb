class Api::V1::MarketResearchesController < ApplicationController
  include Searchable
  search_by :countries, :industry, :q
end
