module DataSources
  class ExternalMappingTransformation < CachedApiEndpoint
    def initialize(options)
      @options = options
      super(options[:ttl])
    end

    def transform(value)
      transformed_value = nil
      @options[:urls].each do |hash|
        transformed_value = transform_value(value, hash)
        break if transformed_value.present?
      end
      transformed_value
    end

    def transform_value(value, hash)
      url_template = hash[:url]
      result_path = hash[:result_path]
      multi_value = hash[:multi_value]
      result = JsonPath.on(cached_response_for(url_template, value), result_path)
      result = result.first unless multi_value
      result
    rescue Exception => e
      Rails.logger.warn "Unable to get mapping for #{value} from #{url_template}: #{e.message}"
      nil
    end
  end
end
