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

  get '/data_sources_documentation' => 'data_sources#documentation'

  concern :api_v2_routable do
    get '/ita_faqs/:id' => 'salesforce_articles/faq#show', constraints: { id: /.+/ }, format: false
  end

  concern :api_routable do
    mapping = { 'salesforce_articles/faq' => 'ita_faqs' }

    mapping.each do |controller, path|
      get "/#{path}/search(.json)" => "#{controller}#search", format: false
    end

    scope '/consolidated_screening_list' do
      get '/search', to: 'screening_lists/consolidated#search'
    end

    scope '/market_intelligence' do
      get 'search', to: 'salesforce_articles/consolidated#search'
    end

    scope '/ita_taxonomies' do
      get 'search', to: 'ita_taxonomy#search'
      get 'query_expansion', to: 'ita_taxonomy#query_expansion'
      get 'suggest', to: 'ita_taxonomy_suggestions#search'
      get ':id', to: 'ita_taxonomy#show', constraints: { id: /.+/ }, format: false
    end
  end

  scope 'v2', module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope module: 'api/v2', defaults: { format: :json } do
    concerns :api_routable
    concerns :api_v2_routable
  end

  scope module: 'api/v2', defaults: { format: :json } do
    apis_migrated_to_endpointme = %w(
      business_service_providers
      tariff_rates
      trade_leads
      trade_events
      ita_office_locations
      ita_zipcode_to_post
      market_research_library
    )
    apis_migrated_to_endpointme.each do |legacy_endpoint|
      get "/#{legacy_endpoint}/search(.json)", to: 'api_models#search', version_number: 1, api: legacy_endpoint.to_sym
      get "/#{legacy_endpoint}/*id", to: 'api_models#show', version_number: 1, api: legacy_endpoint.to_sym
    end

    get '/v*version_number/*api/search(.json)', to: 'api_models#search', constraints: ApiModelRouteConstraint.new
    get '/v*version_number/*api/freshen(.json)', to: 'admin#freshen', constraints: ApiModelRouteConstraint.new
    get '/v*version_number/*api/*id', to: 'api_models#show', constraints: ApiModelRouteConstraint.new
  end

  match '404', via: :all, to: 'api#not_found'

  mount S3Browser::Engine, at: '/s3_browser', constraints: S3BrowserConstraint.new
end
