module TaxonomyMethods
  attr_accessor :taxonomy_parser

  def get_missing_country(mappable_field)
    country_array = normalize_industry('Missing Country: ' + mappable_field)
    country_array.nil? ? nil : lookup_country(country_array.first)
  end

  def set_taxonomy_parser
    self.taxonomy_parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
    taxonomy_parser.concepts = YAML.load_file(Rails.configuration.frozen_taxonomy_concepts)
  end

  def get_geo_terms(country, type)
    fail 'Must implement parser (include set_taxonomy_parser in import)' unless self.class.method_defined?(:taxonomy_parser)
    taxonomy_parser.get_all_geo_terms_for_country(country).select do |term|
      term[:concept_groups].include?(type)
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
