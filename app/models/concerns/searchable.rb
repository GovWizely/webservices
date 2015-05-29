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
    end
  end

  module ClassMethods
    def search_for(options)
      query = query_class(options[:api_version]).new(options)

      search_options = {
        index: index_names(query.try(:sources)),
        body:  query.generate_search_body,
        from:  query.offset,
        size:  query.size,
        sort:  query.sort,
      }

      search_options[:type] = index_type if index_type

      hits = ES.client.search(search_options)['hits'].deep_symbolize_keys
      hits[:offset] = query.offset
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

    def index_type
      nil
    end

    def index_names(sources = nil)
      models = model_classes
      if sources && sources.any?
        selected_models = models.select { |c| sources.include?(c.source[:code]) }

        # If the given sources do not match any models, we'll search over them
        # all. This prevents us from querying EVERY index in our DB, which is
        # undesirable. It would be better if we didn't send a query to ES in this
        # case.
        models = selected_models if selected_models.any?
      end
      models.map(&:index_name)
    end

    def fetch_all
      search_options = { scroll: '5m', search_type: 'scan', index: index_names }
      search_options[:type] = index_type if index_type
      response = ES.client.search(search_options)

      results = []

      while response = ES.client.scroll(scroll_id: response['_scroll_id'], scroll: '5m')
        break if response['hits']['hits'].empty?
        batch = response['hits']['hits'].map(&:deep_symbolize_keys)
        results.push(*batch)
      end

      results
    end
  end
end
