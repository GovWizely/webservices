module TaxonomyMethods
  def add_related_fields(terms)
    terms = terms.compact
    related_fields = { trade_regions: [], world_regions: [] }
    search_results = terms.empty? ? [] : ItaTaxonomy.search_related_terms(labels: terms.join(','))

    search_results.each do |result|
      related_fields.merge!(result[:related_terms]) { |_key, old_val, new_val| old_val | new_val }
    end
    related_fields
  end
end
