S3Browser::Engine.setup do |config|
  config.aws_credentials = Rails.configuration.aws_credentials
end
