local_user = ENV['USER'] || ENV['USERNAME']
current_revision = "-r #{Regexp.last_match[1]}" if release_path =~ /\/(\d+)$/

# Notify NewRelic of the deployment, if NewRelic is present
if ::File.exist?("#{release_path}/config/newrelic.yml")
  run "cd #{release_path} ; bundle exec newrelic deployments -u \"#{local_user}\" #{current_revision}"
end

# Notify AirBrake of the deployment, if AirBrake is present
if ::File.exist?("#{release_path}/config/initializers/airbrake.rb")
  run "cd #{release_path} ; bundle exec rake airbrake:deploy"
end

Chef::Log.info('Creating new indices')
run "cd #{release_path} ; bundle exec rake db:create"

Chef::Log.info('Recreating indices with modified mappings')
run "cd #{release_path} ; bundle exec rake ita:recreate_indices_with_modified_mappings"

Chef::Log.info('Importing empty indices')
run "cd #{release_path} ; bundle exec rake ita:import_empty_indices"
