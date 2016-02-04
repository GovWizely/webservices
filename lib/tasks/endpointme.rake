namespace :endpointme do
  desc 'Import data for a published URL-based api (e.g., business_service_providers)'
  task :import, [:api] => :environment do |_t, args|
    DataSource.freshen args.api
  end
end
