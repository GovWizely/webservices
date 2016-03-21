module DataSources
  class ExternalMappingTransformation

    def initialize(options)
      @options = options
    end

    def transform(value)
      transformed_value = nil
      @options[:urls].each do |hash|
        transformed_value = transform_value(value, hash[:url], hash[:result_path])
        break if transformed_value.present?
      end
      transformed_value
    end

    def transform_value(value, url_template, result_path)
      url = url_template.sub('ORIGINAL_VALUE', URI.encode(value))
      JsonPath.on(json_response_from(url), result_path).first
    rescue Exception => e
      Rails.logger.warn "Unable to get mapping for #{value} from #{url}: #{e.message}"
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
