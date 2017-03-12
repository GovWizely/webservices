require 'simplecov'
SimpleCov.start 'rails'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'shoulda/matchers'
# require 'rspec/autorun'
require 'webmock/rspec'
require 'vcr'
VCR.configure do |c|
  c.ignore_request do |request|
    URI(request.uri).port == 9200
  end
  c.ignore_hosts 'codeclimate.com'
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.debug_logger = File.open('log/vcr.log', 'w')
  c.default_cassette_options = { record: :none }
  c.filter_sensitive_data('<BITLY_API_TOKEN>') { Rails.configuration.bitly_api_token }
  c.configure_rspec_metadata!
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
require Rails.root.join('spec/importers/concerns/can_import_all_sources_behavior.rb')

RSpec.configure do |config|
  config.before(:suite) do
    ES.client.indices.put_template name: 'one_shard', body: { template: 'test:*', settings: { number_of_shards: 1, number_of_replicas: 0 } }
    User.create_index!
    UrlMapper.recreate_index
    ItaTaxonomy.recreate_index unless ItaTaxonomy.index_exists?
  end

  config.after(:suite) do
    User.gateway.delete_index!
    ES.client.indices.delete_template name: 'one_shard'
  end
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # use rspec 2 spec type infer
  config.infer_spec_type_from_file_location!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.include Devise::TestHelpers, type: :controller

  config.filter_run_excluding skip: true
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
