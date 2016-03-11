module TaxonomyMethods
  def get_missing_country(mappable_field)
    country_array = normalize_industry('Missing Country: ' + mappable_field)
    country_array.nil? ? nil : lookup_country(country_array.first)
  end

  def taxonomy_parser
    unless @taxonomy_parser
      @taxonomy_parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
      @taxonomy_parser.concepts = YAML.load_file(Rails.configuration.frozen_taxonomy_concepts)
    end
    @taxonomy_parser
  end

  def get_geo_terms(country, type)
    taxonomy_parser.get_all_geo_terms_for_country(country).select do |term|
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
