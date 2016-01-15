class CountriesTopicsQuery < Query
  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
    @countries = options[:countries].downcase.split(',') if options[:countries].present?
    @topics = options[:topics].downcase.split(',') if options[:topics].present?
  end

  def generate_query(json)
    generate_multi_match_query(json, @multi_fields, @q)
  end

  def generate_filter(json)
    terms_filter_from_field_mapping(json, @field_mapping)
  end
end
