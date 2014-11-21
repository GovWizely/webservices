class Api::V2::SharepointTradeArticlesController < ApplicationController
  include Searchable
  search_by :creation_date_start, :creation_date_end, :release_date_start, :release_date_end,
            :expiration_date_start, :expiration_date_end, :export_phases, :industries, :trade_regions,
            :trade_programs, :trade_initiatives, :countries,
            :topics, :sub_topics, :geo_regions, :geo_subregions, :q
end
