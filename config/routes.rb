Webservices::Application.routes.draw do
  scope module: 'api/v1', constraints: ApiConstraint.new(default: true, version: 1), defaults: { format: :json } do

    path = { 'market_researches' => 'market_research_library',
             'parature_faq'      => 'faqs',
     }

    # Paths for the rest of the controllers are
    # the snake-case versions of their names.
    Dir[Rails.root.join('app/controllers/api/v1/*.rb').to_s].map do |filename|
      controller = File.basename(filename, '.rb').sub('_controller', '')
      path[controller] ||= controller
    end

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
      %w(australia costa_rica el_salvador guatemala korea).each do |source|
        get "/#{source}/search", to: "tariff_rates/#{source}#search"
      end
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
end
