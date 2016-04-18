module QueryParser
  def self.parse(q)
    taxonomy_search_results = ItaTaxonomy.search_related_terms(q: q, types: 'Countries,World Regions')
    parsed_q = q.dup.downcase

    return_hash = {}
    return_hash[:terms] = taxonomy_search_results.map do |result|
      next unless parsed_q.include?(result[:label].downcase)
      parsed_q.slice! result[:label].downcase
      parsed_q = parsed_q.strip
      { label: result[:label], type: result[:type] }
    end.compact

    return_hash[:parsed_q] = parsed_q
    return_hash
  end
end
