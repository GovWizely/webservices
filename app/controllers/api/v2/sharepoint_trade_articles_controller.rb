class Api::V2::SharepointTradeArticlesController < Api::V2Controller
  search_by :creation_date, :release_date, :expiration_date, :export_phases, :industries, :trade_regions,
            :trade_programs, :trade_initiatives, :countries,
            :topics, :sub_topics, :geo_regions, :geo_subregions, :q
end
