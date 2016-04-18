class Api::V2::SalesforceArticles::FaqController < Api::V2Controller
  search_by :q, :countries, :industries, :topics, :trade_regions, :world_regions,
            :first_published_date, :last_published_date
end
