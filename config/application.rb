require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require 'action_controller/railtie'
# require "action_mailer/railtie"
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Webservices
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

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
      Dir[Rails.root.join('app/models/**/*.rb').to_s].map do |filename|
        klass = filename.gsub(/(^.+models\/|\.rb$)/, '').camelize.constantize
        klass.is_a?(Indexable) ? klass : nil
      end.compact
    end

    config.sharepoint_trade_article = {
      aws: {
        region:            ENV['AWS_REGION'],
        access_key_id:     ENV['SHAREPOINT_TRADE_ARTICLE_AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['SHAREPOINT_TRADE_ARTICLE_AWS_SECRET_ACCESS_KEY'] } }
    config.tariff_rate = {
      aws: {
        region:            ENV['AWS_REGION'],
        access_key_id:     ENV['TARIFF_RATE_AWS_ACCESS_KEY_ID'],
        secret_access_key: ENV['TARIFF_RATE_AWS_SECRET_ACCESS_KEY'] } }
  end
end
