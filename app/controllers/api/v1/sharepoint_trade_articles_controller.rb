class Api::V1::SharepointTradeArticlesController < ApplicationController
  include Searchable
  #search_by :evergreen, :pub_date_start, :pub_date_end, :update_date_start, :update_date_end, :q
end