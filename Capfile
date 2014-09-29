# Allow deployment via a (submodule or otherwise provided) Capistrano
# configuration in the top-level project dir /capistrano
cap_dir = File.join(File.dirname(__FILE__), 'capistrano')

if File.directory?(cap_dir) || File.symlink?(cap_dir)
  $LOAD_PATH.unshift(cap_dir)
  load 'deploy'
  # Uncomment if you are using Rails' asset pipeline
  # load 'deploy/assets'
  load 'capistrano/deploy' # remove this line to skip loading any of the default tasks
end
