source 'https://rubygems.org'

gem 'rails', '4.0.9'

gem 'activeresource'
gem 'aws-sdk-core', '~> 2.9' # https://github.com/aws/aws-sdk-ruby/issues/1041
gem 'devise', '~> 3.4.0' # https://github.com/plataformatec/devise/issues/3624
gem 'elasticsearch'
gem 'elasticsearch-persistence'
gem 'elasticsearch-model'
gem 'iso_country_codes'
gem 'jbuilder'
gem 'nokogiri'
gem 'rack-contrib'
gem 'rake'
gem 'sanitize'
gem 'htmlentities'
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'haml'
gem 'charlock_holmes', '0.7.4'
gem 'kramdown'
gem 'rouge', '1.11.1'

gem 'sass'
gem 'jquery-rails'

gem 'industry_mapping_client', git: 'https://github.com/GovWizely/industry_mapping_client.git'
gem 'taxonomy_parser', git: 'https://github.com/GovWizely/taxonomy_parser.git'
gem 's3_browser', git: 'https://github.com/GovWizely/s3_browser.git', ref: '09857a81d65ec5ee2789a167dd3393d20364b071'

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
