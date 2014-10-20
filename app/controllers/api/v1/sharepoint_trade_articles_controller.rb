class Api::V1::SharepointTradeArticlesController < ApplicationController
  include Searchable
  search_by :title, :short_title, :summary, :creation_date_start, :creation_date_end,
            :release_date_start, :release_date_end, :expiration_date_start, :expiration_date_end,
            :content, :keyword, :export_phases, :industries, :trade_regions, :trade_programs,
            :trade_initiatives, :countries, :source_agency, :source_business_units, :source_offices,
            :topic, :sub_topics, :geo_region, :geo_subregions, :q
end
