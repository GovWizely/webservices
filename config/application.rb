require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
# require "active_record/railtie"
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

ENV['SITE_DOMAIN'] ||= 'govwizely.com'

module Webservices
  class Application < Rails::Application
    config.eager_load_paths += Dir["#{config.root}/lib/**/"]
    config.eager_load_paths += Dir["#{config.root}/app/importers/"]
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

    config.developerportal_url =
      if ENV['SITE_DOMAIN'] == 'govwizely.com'
        'http://govwizely.github.io/developerportal'
      else
        "http://developer.#{ENV['SITE_DOMAIN']}"
      end

    config.mailer_sender = "No-Reply@#{ENV['SITE_DOMAIN']}"
    config.action_mailer.default_url_options = { host: "https://api.#{ENV['SITE_DOMAIN']}" }

    config.action_mailer.delivery_method = :smtp
    smtp_settings = {
      address:              ENV['SMTP_ADDRESS'],
      enable_starttls_auto: true,
    }
    smtp_settings[:user_name] = ENV['SMTP_USER_NAME'] if ENV['SMTP_USER_NAME']
    smtp_settings[:password] = ENV['SMTP_PASSWORD'] if ENV['SMTP_PASSWORD']
    smtp_settings[:authentication] = ENV['SMTP_AUTHENTICATION'] if ENV['SMTP_AUTHENTICATION']
    config.action_mailer.smtp_settings = smtp_settings

    config.filter_parameters += [:current_password, :password, :password_confirmation]

    config.staff_email_domains = %w(govwizely.com rrsoft.co)
  end
end
