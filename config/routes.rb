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
      get '/dpl/search', to: 'screening_lists/dpl#search'
      get '/dtc/search', to: 'screening_lists/dtc#search'
      get '/el/search', to: 'screening_lists/el#search'
      get '/fse/search', to: 'screening_lists/fse#search'
      get '/isn/search', to: 'screening_lists/isn#search'
      get '/sdn/search', to: 'screening_lists/sdn#search'
      get '/uvl/search', to: 'screening_lists/uvl#search'
    end
  end
end
