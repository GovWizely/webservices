source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.9'

gem 'aws-sdk-core'
gem 'devise', '~> 3.4.0' # https://github.com/plataformatec/devise/issues/3624
gem 'elasticsearch', git: 'https://github.com/loren/elasticsearch-ruby.git'
gem 'elasticsearch-persistence', git: 'https://github.com/loren/elasticsearch-rails.git'
gem 'elasticsearch-model'
gem 'iso_country_codes'
gem 'jbuilder'
gem 'monetize'
gem 'nokogiri'
gem 'parslet'
gem 'rack-contrib'
gem 'rake'
gem 'sanitize'
gem 'htmlentities'
gem 'us_states', git: 'https://github.com/GSA-OCSIT/us_states.git'
gem 'rubyzip'
gem 'smarter_csv'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'sinatra', require: nil
gem 'mechanize'
gem 'haml'
gem 'roo'
gem 'roo-xls'
gem 'jsonpath'
gem 'charlock_holmes'
gem 'kramdown'
gem 'rouge', '1.11.1'

gem 'sass'
gem 'jquery-rails'

gem 'industry_mapping_client', git: 'https://github.com/GovWizely/industry_mapping_client.git'
gem 'taxonomy_parser', git: 'https://github.com/GovWizely/taxonomy_parser.git'
gem 's3_browser', git: 'https://github.com/GovWizely/s3_browser.git'

gem 'restforce'

group :production do
  gem 'airbrake'
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'thin'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-remote'
end

group :development do
  gem 'capistrano'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'rubocop', '0.39.0', require: false
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'launchy'
  gem 'shoulda-matchers'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
