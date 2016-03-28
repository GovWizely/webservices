Webservices::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'localhost',
    port:                 1025,
    enable_starttls_auto: false,
    openssl_verify_mode:  'none',
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  config.action_dispatch.default_headers['Access-Control-Allow-Origin'] = '*'

  config.developerportal_url = 'http://localhost:4000/developerportal'

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  config.bitly_api_token = 'NOTAREALBITLYAPITOKENIHOPE'

  config.protege_url = 'replace_this_with_protege_url'

  config.enable_bitly_lookup = false
  config.enable_industry_mapping_lookups = false
end
