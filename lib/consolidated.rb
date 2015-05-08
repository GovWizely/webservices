module Consolidated
  def self.extended(base)
    base.class_eval do
      class << self
        attr_accessor :query_class
        attr_accessor :model_classes
      end
    end
  end

  def search_for(options)
    klass = "V#{options[:api_version]}::#{query_class.name}".constantize rescue query_class
    query = klass.new(options)
    hits = ES.client.search(
      index: index_names(query.sources),
      body:  query.generate_search_body,
      from:  query.offset,
      size:  query.size,
      sort:  query.sort)['hits'].deep_symbolize_keys
    hits[:offset] = query.offset
    hits.deep_symbolize_keys
  end

  def index_names(sources)
    models = model_classes

    if sources.any?
      selected_models = models.select { |c| sources.include?(c.source[:code]) }

      # If the given sources do not match any models, we'll search over them
      # all. This prevents us from querying EVERY index in our DB, which is
      # undesirable. It would be better if we didn't send a query to ES in this
      # case.
      models = selected_models if selected_models.any?
    end

    models.map(&:index_name)
  end
end
