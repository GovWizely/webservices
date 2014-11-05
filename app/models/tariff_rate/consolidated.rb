module TariffRate
  class Consolidated
    def self.search_for(options)
      query = TariffRate::Query.new(options)
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
      classes = [Australia, CostaRica, ElSalvador, Guatemala, Korea]
      classes = classes.select { |c| sources.include?(c.source) } if sources.any?

      classes.map(&:index_name)
    end
  end
end
