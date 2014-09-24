module ScreeningList
  class Consolidated
    def self.search_for(options)
      query = Query.new(options)
      hits = ES::client.search(
          index: index_names(query.sources),
          body: query.generate_search_body,
          from: query.offset,
          size: query.size,
          sort: query.sort)['hits'].deep_symbolize_keys
      hits[:offset] = query.offset
      hits.deep_symbolize_keys
    end

    def self.index_names(sources)
      classes = [Dpl, El, Uvl, Fse, Isn, Dtc, Sdn]
      classes = classes.find_all { |c| sources.include?(c.source) } if (sources.any?)

      classes.collect(&:index_name)
    end
  end
end
