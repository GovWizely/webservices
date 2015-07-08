class ES
  INDEX_PREFIX = "#{Rails.env}:webservices".freeze

  cattr_accessor :default_url
  self.default_url = ENV['ES_URL'] ? ENV['ES_URL'].dup : 'http://127.0.0.1:9200'
  default_url.freeze

  def self.client
    @@client ||= Elasticsearch::Client.new(url: default_url, log: Rails.env == 'development')
  end
end
