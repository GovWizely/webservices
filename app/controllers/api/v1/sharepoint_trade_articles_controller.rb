class Api::V1::SharepointTradeArticlesController < ApplicationController
  include Searchable
  search_by :title, :short_title, :summary, :creation_date_start, :creation_date_end
end