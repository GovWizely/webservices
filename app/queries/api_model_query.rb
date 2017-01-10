class ApiModelQuery < Query
  def initialize(metadata, options = {})
    initialize_filter_fields(metadata)
    pluralized_key_strings = metadata.pluralized_filter_fields.keys
    options.keys.each { |k| options[k.singularize] = options.delete(k) if pluralized_key_strings.include?(k.to_sym) }
    self.class.aggregate_terms_by(metadata.aggregation_terms)
    self.class.setup_query(q: var_field_mapping(metadata.fulltext_fields).values, filter: metadata.filter_fields.keys + @date_fields.keys, raw_enabled: metadata.fulltext_fields.keys + metadata.filter_fields.keys)
    super(options.merge(semantic_query_service_configuration: metadata.semantic_query_service_configuration))
  end

  private

  def initialize_filter_fields(metadata)
    @date_fields = var_field_mapping(metadata.date_fields)
    @plural_filter_fields = var_field_mapping(metadata.plural_filter_fields)
    @singular_filter_fields = var_field_mapping(metadata.singular_filter_fields)
  end

  def var_field_mapping(hash)
    hash.map { |field, meta| [field, meta.fetch(:search_path, field).to_s] }.to_h
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          @plural_filter_fields.each_pair do |field, search_path|
            terms_child(json, field, search_path)
          end
          @singular_filter_fields.each_pair do |field, search_path|
            term_child(json, field, search_path)
          end
          @date_fields.each_pair do |field, search_path|
            date_range_child(json, field, search_path)
          end
        end
      end
    end
  end

  def terms_child(json, field, search_path)
    value = instance_variable_get("@#{field}")
    json.child! { generate_terms(json, search_path, csv_to_normalized_array(value)) } if value
  end

  def term_child(json, field, search_path)
    value = instance_variable_get("@#{field}")
    json.child! { json.term { json.set! search_path, value.downcase.squish } } if value
  end

  def date_range_child(json, field, search_path)
    value = instance_variable_get("@#{field}")
    generate_date_range(json, search_path, value) if value
  end

  def csv_to_normalized_array(value)
    value.split(',').map do |entry|
      entry.downcase.squish
    end
  end
end
