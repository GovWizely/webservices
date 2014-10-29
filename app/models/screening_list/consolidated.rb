module ScreeningList
  class Consolidated
    def self.search_for(options)
      query = ScreeningList::Query.new(options)
      hits = ES.client.search(
          index: index_names(query.sources),
          body:  query.generate_search_body,
          from:  query.offset,
          size:  query.size,
          sort:  query.sort)['hits'].deep_symbolize_keys
      hits[:offset] = query.offset
      hits.deep_symbolize_keys
    end

    def self.index_names(sources)
      models = [Dpl, Dtc, El, Fse, Isn, Plc, Sdn, Ssi, Uvl]

      if sources.any?
        selected_models = models.select { |c| sources.include?(c.source[:code]) }

        # If the given sources do not match any CSL models, we'll search over
        # them all. This prevents us from querying EVERY index in our DB, which
        # is undesirable. It would be better if we didn't send a query to ES
        # in this case.
        models = selected_models if selected_models.any?
      end

      models.map(&:index_name)
    end
  end
end
