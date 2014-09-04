Webservices::Application.routes.draw do
  scope module: 'api/v1', constraints: ApiConstraint.new(default: true, version: 1), defaults: { format: :json } do

    path = {
      'market_researches'                 => 'market_research_library',
      'bis_denied_people'                 => 'denied_persons_list',
      'ddtc_aeca_debarred_parties'        => 'aeca_debarred_list',
      'bis_entities'                      => 'entity_list',
      'bisn_foreign_sanctions_evaders'    => 'foreign_sanctions_evaders_list',
      'bisn_nonproliferation_sanctions'   => 'nonproliferation_sanctions',
      'ofac_special_designated_nationals' => 'special_designated_nationals_list',
      'bis_unverified_parties'            => 'unverified_list',
      'consolidated_screening_entries'    => 'consolidated_screening_list',
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
  end
end
