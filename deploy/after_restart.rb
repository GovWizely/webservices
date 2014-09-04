 local_user = ENV['USER'] || ENV['USERNAME']
 current_revision = "-r #{$1}" if release_path =~ /\/(\d+)$/

 # Notify NewRelic of the deployment, if NewRelic is present
 if ::File.exists?("#{release_path}/config/newrelic.yml")
   run "cd #{release_path} ; bundle exec newrelic deployments -u \"#{local_user}\" #{current_revision}"
 end

 # Notify AirBrake of the deployment, if AirBrake is present
 if ::File.exists?("#{release_path}/config/initializers/airbrake.rb")
   run "cd #{release_path} ; bundle exec rake airbrake:deploy"
 end
