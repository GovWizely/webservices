# See also: the Indexable concern.
#
# Searchable provides the ability to search over a set of indexes. Indexable
# provides the ability to index documents into an ES index. It is possible to
# have a module that can perform searches but cannot index documents. A
# specific example is the case where the model represents a consolidated
# endpoint. In such a case, you must set the model_classes attribute, so that
# Seachable can use those models to figure out which indexes it should perform
# the search against.

module Searchable
  extend ActiveSupport::Concern

  included do
    class << self
      attr_accessor :model_classes
      attr_accessor :fetch_all_sort_by
    end

    # Defaults to itself. This makes sense when the model is also Indexable,
    # as we're only dealing with a single source. model_classes will get
    # manually set in a non-Indexable (i.e. consolidated) model.
    self.model_classes = [self]
  end

  module ClassMethods
    def search_for(options)
      query = query_class(options[:api_version]).new(options)

      search_options = {
        index: index_names(query.try(:sources)),
        type:  (model_classes.map { |mc| mc.to_s.typeize } rescue nil),
        body:  query.generate_search_body,
        from:  query.offset,
        size:  query.size,
        sort:  query.sort,
      }

      search_options[:type] = index_type if index_type
      search_options[:search_type] = query.search_type if query.search_type

      hits = ES.client.search(search_options)['hits'].deep_symbolize_keys
      hits[:offset] = query.offset
      hits[:sources_used] = index_meta(query.try(:sources))
      hits.deep_symbolize_keys
    end

    def query_class(api_version = nil)
      query_class =
        if name.split('::').last == 'Consolidated'
          name.sub('Consolidated', 'Query').constantize
        else
          "#{name}Query".constantize
        end

      if api_version
        with_version = "V#{api_version}::#{query_class}".constantize rescue nil
        query_class = with_version if with_version
      end

      query_class
    end

    # The Indexable concern will override this if included. In the case where
    # a model is Searchable but not Indexable (i.e. a model representing a
    # consolidated set of sources), we still call this method when performing
    # a search. The fact that it returns nil tell us not to set the types
    # of document to search for when doing so.
    def index_type
      nil
    end

    def fetch_all(sources = nil)
      search_options = { scroll: '5m', index: index_names, type: index_types(sources) }
      search_options[:sort] = fetch_all_sort_by if fetch_all_sort_by

      response = ES.client.search(search_options)
      results = { offset:       0,
                  sources_used: index_meta(sources),
                  hits:         response['hits'].deep_symbolize_keys[:hits],
                  total:        response['hits']['total'] }

      while response = ES.client.scroll(scroll_id: response['_scroll_id'], scroll: '5m')
        batch = response['hits'].deep_symbolize_keys
        break if batch[:hits].empty?
        results[:hits].concat(batch[:hits])
      end

      results
    end

    def index_names(sources = nil)
      models(sources).map(&:index_name)
    end

    def index_meta(sources = nil)
      models(sources).map do |model|
        {
          source:              model.source[:full_name] || model.source[:code],
          source_last_updated: model.stored_metadata[:last_updated] || '',
          last_imported:       model.stored_metadata[:last_imported] || '',
        }
      end
    end

    private

    def models(sources)
      models = model_classes
      if sources.try(:any?)
        selected_models = models.select { |c| sources.include?(c.source[:code]) }

        # If the given sources do not match any models, we'll search over them
        # all. This prevents us from querying EVERY index in our DB, which is
        # undesirable. It would be better if we didn't send a query to ES in this
        # case.
        models = selected_models if selected_models.any?
      end
      models
    end

    def index_types(sources = nil)
      models(sources).map(&:index_type)
    end
  end
end
