module ES
  INDEX_PREFIX = "#{Rails.env}:webservices".freeze

  def self.client
    @@client ||= Elasticsearch::Client.new(log: Rails.env == 'development')
  end
end
