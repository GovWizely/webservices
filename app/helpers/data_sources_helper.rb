module DataSourcesHelper
  def sample_api_call(data_source, with_params = true)
    example_data_source = data_source.is_consolidated? ? data_source.sources_map.values.first : data_source
    url = "/v#{data_source.version_number}/#{data_source.api}/search.json?#{sample_params_from_data_source(example_data_source.metadata, with_params)}"
    link_to url, url
  end

  def param_table(field_hash)
    content_tag(:dl, class: 'dl-horizontal') do
      field_hash.each do |field, hash|
        concat content_tag(:dt, field)
        concat content_tag(:dd, hash[:description])
      end
    end
  end

  private

  def sample_params_from_data_source(metadata, with_params)
    groups = ["api_key=#{current_user.api_key}"]
    if with_params
      groups << keys_map(metadata.singular_filter_fields, 'VALUE')
      groups << keys_map(metadata.pluralized_filter_fields, 'VALUE')
      groups << keys_map(metadata.date_fields, 'YYYY-MM-DD+TO+YYYY-MM-DD')
      groups << 'q=TEXT' if metadata.fulltext_fields.present?
    end
    groups.compact.join('&')
  end

  def keys_map(fields_hash, default_value)
    fields_hash.keys.map { |key| "#{key}=#{default_value}" }.join('&') if fields_hash.present?
  end
end
