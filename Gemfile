source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.9'

gem 'airbrake'
gem 'aws-sdk-core'
gem 'devise'
gem 'elasticsearch'
gem 'elasticsearch-persistence'
gem 'iso_country_codes'
gem 'jbuilder'
gem 'monetize'
gem 'nokogiri', '~> 1.6.0'
gem 'parslet'
gem 'rack-contrib'
gem 'rake'
gem 'sanitize', '~> 2.0.6'
gem 'htmlentities'
gem 'us_states', git: 'git://github.com/GSA-OCSIT/us_states.git'
gem 'git'
gem 'rdiscount'
gem 'rubyzip'
gem 'smarter_csv'
gem 'sidekiq'
gem 'sinatra', require: nil
gem 'mechanize'
gem 'haml'
gem 'roo'
gem 'roo-xls'
gem 'jsonpath'
gem 'charlock_holmes'

gem 'sass'
gem 'jquery-rails'

gem 'industry_mapping_client', git: 'git://github.com/GovWizely/industry_mapping_client.git'
gem 'taxonomy_parser', github: 'GovWizely/taxonomy_parser'

group :staging, :staging2, :production do
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'shoulda-matchers', require: false
  gem 'thin'
  gem 'pry-rails'
  gem 'pry-byebug', '~> 1.3.3'
  gem 'pry-remote'
end

group :development do
  gem 'capistrano',  '~> 2.15'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'foreman'
  gem 'rubocop', require: false
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', require: false
  gem 'capybara'
  gem 'launchy'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
