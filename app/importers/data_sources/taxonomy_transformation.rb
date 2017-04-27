module DataSources
  class TaxonomyTransformation < CachedApiEndpoint
    MAPPER_TEMPLATE = "http://localhost:3001/api/terms.json?mapped_term=ORIGINAL_VALUE&source=I94MonthlyData&log_failed=true"
    TAXONOMY_TEMPLATE = "https://api.trade.gov/ita_taxonomies/search.json?size=1&types=Countries&api_key=%s&q=ORIGINAL_VALUE"

    def initialize(options)
      @options = options
      super(options[:ttl])
    end

    def transform(value)
      transformed_value = nil
      mapper_response = JSON.parse(cached_response_for(MAPPER_TEMPLATE, value))
      term = mapper_response.first unless mapper_response.empty?
      if country_should_be_added?(term)
        transformed_value = term["name"]
      elsif world_regions_should_be_added?(term)
        transformed_value = add_world_region(term, mapper_response)
      end
      transformed_value
    end

    private

    def add_world_region(term, mapper_response)
      if term["taxonomies"].include?("Countries")
        country = term["name"]
        taxonomy_response = JSON.parse(cached_response_for(TAXONOMY_TEMPLATE % @options[:api_key], country))
        return taxonomy_response["results"].first["related_terms"]["world_regions"]
      elsif term["taxonomies"].include?("World Regions")
        return mapper_response.map{ |term| term["name"] }
      end
    end

    def country_should_be_added?(term)
      term && @options[:field_type] == "country" && term["taxonomies"].include?("Countries")
    end

    def world_regions_should_be_added?(term)
      term && @options[:field_type] == "world_region"
    end
  end
end