Webservices::Application.routes.draw do
  concern :api_v1_routable do
    path = {
      'australian_trade_leads' => 'AUSTRALIA',
      'canada_leads'           => 'CANADA',
      'fbopen_leads'           => 'FBO',
      'state_trade_leads'      => 'STATE',
      'uk_trade_leads'         => 'UK',
    }

    path.each do |path, source|
      get "/#{path}/search(.json)" => 'trade_leads/consolidated#search', format: false, defaults: { sources: source }
    end

  end

  concern :api_routable do

    path = { 'market_researches'         => 'market_research_library',
             'parature_faq'              => 'faqs',
             'ita_office_locations'      => 'ita_office_locations',
             'trade_articles'            => 'trade_articles',
             'sharepoint_trade_articles' => 'ita_articles',
     }

    path.each do |controller, path|
      get "/#{path}/search(.json)" => "#{controller}#search", format: false
    end

    scope '/consolidated_screening_list' do
      get '/search', to: 'screening_lists/consolidated#search'
      %w(dtc dpl el fse isn plc sdn ssi uvl).each do |source|
        get "/#{source}/search", to: "screening_lists/#{source}#search"
      end
    end

    scope '/tariff_rates' do
      get '/search', to: 'tariff_rates/consolidated#search'
      %w(australia costa_rica el_salvador guatemala south_korea).each do |source|
        get "/#{source}/search", to: "tariff_rates/#{source}#search"
      end
    end

    scope '/trade_leads' do
      get '/search', to: 'trade_leads/consolidated#search'
    end

    namespace :trade_events do
      get 'search', to: 'consolidated#search'
      get 'ita/search'
      get 'sba/search'
      get 'exim/search'
      get 'dl/search'
      get 'ustda/search'
    end
  end

  scope 'v2', module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
  end

  scope 'v1', module: 'api/v1', defaults: { format: :json } do
    concerns :api_v1_routable
    concerns :api_routable
  end

  scope module: 'api/v2', constraints: ApiConstraint.new(default: false, version: 2), defaults: { format: :json } do
    concerns :api_routable
  end

  scope module: 'api/v1', constraints: ApiConstraint.new(default: true, version: 1), defaults: { format: :json } do
    concerns :api_v1_routable
    concerns :api_routable
  end

  match '404', via: :all, to: 'application#not_found'
end
