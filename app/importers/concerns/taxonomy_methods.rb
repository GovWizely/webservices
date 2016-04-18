module TaxonomyMethods
  def get_missing_country(mappable_field)
    country_array = normalize_industry('Missing Country: ' + mappable_field)
    country_array.nil? ? nil : country_array.first
  end

  def add_related_fields(terms)
    terms = terms.compact
    related_fields = { trade_regions: [], world_regions: [] }
    search_results = terms.empty? ? [] : ItaTaxonomy.search_related_terms(labels: terms.join(','))

    search_results.each do |result|
      related_fields.merge!(result[:related_terms]) { |_key, old_val, new_val| old_val | new_val }
    end
    related_fields
  end

  #  These will soon be moved to the Taxonomy importer (the only place they should be used!):
  def get_geo_terms(country, type)
    @taxonomy_parser.get_all_geo_terms_for_country(country).select do |term|
      term[:object_properties][:member_of].map { |t| t[:label] }.include?(type)
    end.map { |term| term[:label] }
  end

  def add_geo_fields(countries)
    trade_regions = []
    world_regions = []

    countries.compact.each do |country|
      trade_regions.concat get_geo_terms(country, 'Trade Regions')
      world_regions.concat get_geo_terms(country, 'World Regions')
    end

    {
      trade_regions: trade_regions.uniq,
      world_regions: world_regions.uniq,
    }
  end
end
