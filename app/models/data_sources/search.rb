module DataSources
  class Search
    def initialize(data_source, query, sources)
      @data_source = data_source
      @query = query
      @sources = sources
    end

    def search
      @search_performed_at = DateTime.now.utc
      @data_source.is_consolidated? ? consolidated_search : single_search
    end

    private

    def single_search
      @data_source.with_api_model do |api_model_klass|
        results = api_model_klass.search(@query.generate_search_body_hash)
        response_hash(results, results.response.hits.total)
      end
    end

    def consolidated_search
      @data_source.with_api_models(@sources) do |api_model_klasses|
        results = Elasticsearch::Model.search(@query.generate_search_body_hash, api_model_klasses)
        response_hash(results.records, results.records.total)
      end
    end

    def response_hash(results, total)
      { total:               total,
        offset:              @query.offset,
        sources_used:        sources_used,
        search_performed_at: @search_performed_at,
        results:             results, }
    end

    def sources_used
      data_sources_used = @data_source.is_consolidated? ? @data_source.consolidated_data_sources(@sources) : [@data_source]
      data_sources_used.collect do |data_source|
        { source:              data_source.name,
          source_last_updated: data_source.data_changed_at,
          last_imported:       data_source.data_imported_at, }
      end
    end
  end
end
