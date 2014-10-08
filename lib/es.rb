class ES
  INDEX_PREFIX = "#{Rails.env}:webservices".freeze

  cattr_accessor :default_url
  self.default_url = "http://127.0.0.1:9200".freeze

  def self.client
    @@client ||= Elasticsearch::Client.new(url: default_url, log: Rails.env == 'development')
  end
end
