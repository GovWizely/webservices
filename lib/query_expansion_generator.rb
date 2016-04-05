class QueryExpansionGenerator
  def self.generate(q)
    { query_expansion: build_json(q) }
  end

  def self.build_json(q)
    search_results = ItaTaxonomy.search_related_terms(q: q, types: 'Countries')

    related_terms = parse_query_expansion(search_results, q)
    q = strip_punctuation(q)

    related_terms.each { |_key, array| build_queries(array, q) }
    related_terms
  end

  def self.build_queries(array, q)
    array.map! do |label|
      { label.to_sym => "#{q} #{label}".strip.gsub(/\s+/, ' ') }
    end
  end

  def self.strip_punctuation(string)
    string.downcase.gsub(/[^a-z0-9\s]/i, '')
  end

  def self.parse_query_expansion(search_results, q)
    related_terms = {}
    search_results.each do |term|
      if q.include?(term[:label].downcase)
        related_terms.merge!(term[:related_terms]) { |_key, old_val, new_val| old_val | new_val }
        q.slice!(term[:label].downcase)
      end
    end
    related_terms
  end
end
