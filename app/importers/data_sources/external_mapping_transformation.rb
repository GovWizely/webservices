module DataSources
  class ExternalMappingTransformation

    def initialize(options)
      @options = options
    end

    def transform(value)
      url = @options[:url].sub('ORIGINAL_VALUE', URI.encode(value))
      JsonPath.on(json_response_from(url), @options[:result_path]).first
    rescue Exception => e
      Rails.logger.warn "Unable to get mapping from #{url}: #{e.message}"
      nil
    end

    private

    def json_response_from(url)
      Rails.cache.fetch(url, expires_in: 90.seconds) do
        Net::HTTP.get(URI.parse(url))
      end
    end
  end
end
