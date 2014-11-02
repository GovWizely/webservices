module TradeEvent
  class Consolidated
    def self.search_for(options)
      query = Query.new(options)
      hits = ES.client.search(
          index: index_names,
          body:  query.generate_search_body,
          from:  query.offset,
          size:  query.size,
          sort:  query.sort)['hits'].deep_symbolize_keys
      hits[:offset] = query.offset
      hits.deep_symbolize_keys
    end

    def self.index_names
      [Ita, Sba].map(&:index_name)
    end
  end
end
