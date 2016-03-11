class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
    @query_expansion = options[:query_expansion].downcase if options[:query_expansion].present?

    @query_expansion = parse_query_expansion if @query_expansion
  end

  private

  def generate_filter(json)
    terms_filter_from_field_mapping(json, 'label.keyword' => @query_expansion)
  end

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          generate_match(json, 'label.tokenized', @q)
        end
      end
    end if @q
  end

  def parse_query_expansion
    labels = get_country_labels
    parsed_values = []
    labels.each do |label|
      parsed_values.push(label) if @query_expansion.include?(label)
    end
    parsed_values
  end

  def get_country_labels
    @taxonomy_parser = TaxonomyParser.new(Rails.configuration.frozen_protege_source)
    @taxonomy_parser.concepts = YAML.load_file(Rails.configuration.frozen_taxonomy_concepts)

    @taxonomy_parser.get_concepts_by_concept_group('Countries').map { |term| term[:label].downcase }
  end
end
