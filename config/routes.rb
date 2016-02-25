require 'sidekiq/web'

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

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :data_sources do
    member { get :iterate_version }
  end

  concern :api_v2_routable do
    get '/trade_articles/search(.json)' => 'sharepoint_trade_articles#search'
    get '/ita_faqs/:id' => 'parature_faq#show', constraints: { id: /.+/ }, format: false
    get '/ita_zipcode_to_post/search(.json)'  => 'ita_zip_codes#search'
    get '/trade_events/:id' => 'trade_events/consolidated#show', constraints: { id: /.+/ }, format: false
    get '/trade_leads/:id' => 'trade_leads/consolidated#show', constraints: { id: /.+/ }, format: false
  end

  concern :api_routable do
    mapping = { 'market_researches'    => 'market_research_library',
                'parature_faq'         => 'ita_faqs',
                'ita_office_locations' => 'ita_office_locations',
                'ita_zip_codes'        => 'ita_zipcode_to_post',
                'ita_taxonomy'         => 'ita_taxonomies',
     }

    mapping.each do |controller, path|
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

    scope '/market_intelligence' do
      get 'search', to: 'salesforce_articles/consolidated#search'
    end

  end

  scope 'v2', module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope module: 'api/v2', defaults: { format: :json } do
    get '/ita_zipcode_to_post/search(.json)'  => 'ita_zip_codes#search'
  end

  scope module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope module: 'api/v2', defaults: { format: :json } do
    get '/business_service_providers/search(.json)', to: 'api_models#search', version_number: 1, api: :business_service_providers
    get '/business_service_providers/*id', to: 'api_models#show', version_number: 1, api: :business_service_providers

    get '/v*version_number/*api/search(.json)', to: 'api_models#search', constraints: ApiModelRouteConstraint.new
    get '/v*version_number/*api/*id', to: 'api_models#show', constraints: ApiModelRouteConstraint.new
  end

  match '404', via: :all, to: 'api#not_found'
end
