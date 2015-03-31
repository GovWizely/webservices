Webservices::Application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
    get '/regenerate_api_key', to: 'registrations#regenerate_api_key'
  end

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

    get '/trade_articles/search(.json)' => 'trade_articles#search'

    scope '/consolidated_screening_list' do
      %w(dtc dpl el fse isn plc sdn ssi uvl).each do |source|
        get "/#{source}/search", to: "screening_lists/#{source}#search"
      end
    end

    namespace :trade_events do
      get 'ita/search'
      get 'sba/search'
      get 'exim/search'
      get 'dl/search'
      get 'ustda/search'
    end

  end

  concern :api_v2_routable do

    get '/trade_articles/search(.json)' => 'sharepoint_trade_articles#search'

  end

  concern :api_routable do

    path = { 'market_researches'         => 'market_research_library',
             'parature_faq'              => 'ita_faqs',
             'ita_office_locations'      => 'ita_office_locations',
             'country_commercial_guides' => 'country_commercial_guides',
     }

    path.each do |controller, path|
      get "/#{path}/search(.json)" => "#{controller}#search", format: false
    end

    scope '/consolidated_screening_list' do
      get '/search', to: 'screening_lists/consolidated#search'
    end

    scope '/tariff_rates' do
      get '/search', to: 'tariff_rates/consolidated#search'
    end

    scope '/trade_leads' do
      get '/search', to: 'trade_leads/consolidated#search'
    end

    namespace :trade_events do
      get 'search', to: 'consolidated#search'
    end
  end

  scope 'v2', module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope 'v1', module: 'api/v1', defaults: { format: :json } do
    concerns :api_v1_routable
    concerns :api_routable
  end

  scope module: 'api/v2', constraints: ApiConstraint.new(default: false, version: 2), defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope module: 'api/v1', constraints: ApiConstraint.new(default: true, version: 1), defaults: { format: :json } do
    concerns :api_v1_routable
    concerns :api_routable
  end

  match '404', via: :all, to: 'api#not_found'
end
