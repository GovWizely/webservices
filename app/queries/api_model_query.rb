class ApiModelQuery < Query
  def initialize(data_source, options = {})
    @date_fields = data_source.date_fields.keys
    @filter_fields = data_source.filter_fields.keys
    self.class.setup_query(
      q:      data_source.fulltext_fields.keys,
      filter: @filter_fields + @date_fields,
    )
    super(options)
  end

  private

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          @filter_fields.each do |field|
            terms_child(json, field)
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
    json.child! { json.terms { json.set! field, csv_to_array(value) } } if value
  end

  def date_range_child(json, field)
    value = instance_variable_get("@#{field}")
    generate_date_range(json, field, value) if value
  end

  def csv_to_array(value)
    value.split(',').map(&:strip)
  end
end
