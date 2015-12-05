class ApiModelQuery < Query
  def initialize(data_source, options = {})
    @date_fields = data_source.date_fields.keys
    @plural_filter_fields = data_source.plural_filter_fields.keys
    @singular_filter_fields = data_source.singular_filter_fields.keys
    pluralized_key_strings = data_source.pluralized_filter_fields.keys
    options.keys.each { |k| options[k.singularize] = options.delete(k) if pluralized_key_strings.include?(k.to_sym) }
    self.class.setup_query(q: data_source.fulltext_fields.keys, filter: data_source.filter_fields.keys + @date_fields)
    super(options)
  end

  private

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          @plural_filter_fields.each do |field|
            terms_child(json, field)
          end
          @singular_filter_fields.each do |field|
            term_child(json, field)
          end
          @date_fields.each do |field|
            date_range_child(json, field)
          end
        end
      end
    end
  end

  def terms_child(json, field)
    value = instance_variable_get("@#{field}")
    json.child! { json.terms { json.set! field, csv_to_normalized_array(value) } } if value
  end

  def term_child(json, field)
    value = instance_variable_get("@#{field}")
    json.child! { json.term { json.set! field, value.downcase.squish } } if value
  end

  def date_range_child(json, field)
    value = instance_variable_get("@#{field}")
    generate_date_range(json, field, value) if value
  end

  def csv_to_normalized_array(value)
    value.split(',').map do |entry|
      entry.downcase.squish
    end
  end
end
