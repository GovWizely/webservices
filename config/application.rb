require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, :staging or :production.
Bundler.require(:default, Rails.env)

module Webservices
  class Application < Rails::Application
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.eager_load_paths += Dir["#{config.root}/app/importers/**/"]
    config.eager_load_paths += Dir["#{config.root}/app/workers/"]

    require 'ext/string'
    require 'ext/hash'

    # Disable the asset pipeline.
    config.assets.enabled = false

    config.middleware.use Rack::JSONP

    # This is a default secret_key_base for development that will be overridden if you place
    # a similar entry in config/initializers/secret_token.rb
    config.secret_key_base = '2874915d5abc3ca7314fa1d903ec6a1b2874915d5abc3ca7314fa1d903ec6a1b2874915d5abc3ca7314fa1d903ec6a1b2874915d5abc3ca7314fa1d903ec6a1b'

    config.i18n.enforce_available_locales = false

    config.exceptions_app = routes

    config.cache_store = :memory_store

    def model_classes
      filenames = Dir[Rails.root.join('app/models/**/*.rb').to_s]
      filenames.select { |filename|
        filename !~ /\/concerns\//
      }.map { |filename|
        klass = filename.gsub(/(^.+models\/|\.rb$)/, '').camelize.constantize
        klass.ancestors.include?(Indexable) ? klass : nil
      }.compact
    end

    config.filter_parameters += [:current_password, :password, :password_confirmation]

    # enable url shortener to shorten entries' urls.
    config.enable_bitly_lookup = true
    config.enable_industry_mapping_lookup = true

    config.frozen_protege_source = "#{Rails.root}/data/webprotege.zip"
    config.frozen_taxonomy_concepts = "#{Rails.root}/data/taxonomy/concepts.yaml"

    config.restforce = {
      api_version:   'replace_with_real_value',
      client_id:     'replace_with_real_value',
      client_secret: 'replace_with_real_value',
      host:          'replace_with_real_value',
      username:      'replace_with_real_value',
      password:      'replace_with_real_value',
    }
  end
end
