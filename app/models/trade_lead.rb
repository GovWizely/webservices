class TradeLead
  def self.search_for(options)
    query = TradeLeadQuery.new options
    hits = ES::client.search(
        index: index_names,
        body: query.generate_search_body,
        from: query.offset,
        size: query.size,
        sort: query.sort)['hits'].deep_symbolize_keys
    hits[:offset] = query.offset
    hits.deep_symbolize_keys
  end

  def self.index_names
    @@index_names ||= [CanadaLead, StateTradeLead, UkTradeLead].collect(&:index_name)
  end
end
