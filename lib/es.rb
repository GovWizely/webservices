class ES
  INDEX_PREFIX = "#{Rails.env}:webservices".freeze

  def self.client
    @@client ||= Elasticsearch::Client.new(config)
  end

  private

  def self.config
    config = { url: 'http://127.0.0.1:9200', log: Rails.env == 'development' }

    if File.exist?("#{Rails.root}/config/elasticsearch.yml")
      # :nocov:
      config.merge!(YAML.load_file("#{Rails.root}/config/elasticsearch.yml").symbolize_keys)
      # :nocov:
    end

    config
  end
end
Elasticsearch::Model.client = ES.client
