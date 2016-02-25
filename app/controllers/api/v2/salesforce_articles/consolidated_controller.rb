class Api::V2::SalesforceArticles::ConsolidatedController < Api::V2Controller
  search_by :q, :sources, :countries, :industries, :topics, :trade_regions, :world_regions,
            :first_published_date, :last_published_date
end
