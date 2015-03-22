source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.1'
gem 'rails-api'

gem 'airbrake'
gem 'aws-sdk-core'
gem 'elasticsearch'
gem 'iso_country_codes'
gem 'jbuilder'
gem 'monetize'
gem 'nokogiri', '1.6.0'
gem 'parslet'
gem 'rack-contrib'
gem 'rake'
gem 'sanitize', '~> 2.0.6'
gem 'htmlentities'
gem 'us_states', git: 'git://github.com/GSA-OCSIT/us_states.git'
gem 'git'
gem 'rdiscount'
gem 'smarter_csv'

gem 'industry_mapping_client', git: 'git://github.com/GovWizely/industry_mapping_client.git'

group :production do
  gem 'newrelic_rpm'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'shoulda-matchers'
  gem 'thin'
  gem 'pry-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'capistrano',  '~> 2.15'
  gem 'rubocop', require: false
  gem 'transpec'
end

group :test do
  gem 'webmock'
  gem 'vcr'
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', require: false
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
