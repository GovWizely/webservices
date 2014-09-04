class ConsolidatedScreeningEntry
  def self.search_for(options)
    query = ConsolidatedScreeningEntryQuery.new options
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
    classes = [BisDeniedPerson, BisEntity, BisUnverifiedParty,
               BisnForeignSanctionsEvader, BisnNonproliferationSanction,
               DdtcAecaDebarredParty, OfacSpecialDesignatedNational]
    classes = classes.find_all { |c| sources.include?(c.source) } if (sources.any?)

    classes.collect(&:index_name)
  end
end
