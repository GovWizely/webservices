module DataSourcesHelper
  def sample_api_call(data_source, with_params = true)
    url = "/v#{data_source.version_number}/#{data_source.api}/search.json?#{sample_params_from_data_source(data_source, with_params)}"
    link_to url, url
  end

  def param_table(field_description_hash)
    content_tag(:dl, class: 'dl-horizontal') do
      field_description_hash.each do |field, description|
        concat content_tag(:dt, field)
        concat content_tag(:dd, description)
      end
    end
  end

  private

  def sample_params_from_data_source(data_source, with_params)
    groups = ["api_key=#{current_user.api_key}"]
    if with_params
      groups << keys_map(data_source.filter_fields, 'VALUE')
      groups << keys_map(data_source.date_fields, 'YYYY-MM-DD+TO+YYYY-MM-DD')
      groups << 'q=TEXT' if data_source.fulltext_fields.present?
    end
    groups.compact.join('&')
  end

  def keys_map(fields_hash, default_value)
    fields_hash.keys.map { |key| "#{key}=#{default_value}" }.join('&') if fields_hash.present?
  end
end
