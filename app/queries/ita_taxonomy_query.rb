class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
    @taxonomies = options[:taxonomies].downcase.split(',') if options[:taxonomies].present?
  end

  private

  def generate_filter(json)
    terms_filter_from_field_mapping(json, taxonomies: @taxonomies)
  end

  def generate_query(json)
    multi_fields = %i(name broader_terms narrower_terms)
    generate_multi_match_query(json, multi_fields, @q)
  end
end
