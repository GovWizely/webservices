module DataSourcesHelper
  def sample_api_call(data_source)
    url = "/#{data_source.api}/search.json?#{sample_params_from_data_source(data_source)}"
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

  def sample_params_from_data_source(data_source)
    groups = ["api_key=#{current_user.api_key}"]
    groups << keys_map(data_source.filter_fields, 'VALUE')
    groups << keys_map(data_source.date_fields, 'YYYY-MM-DD+TO+YYYY-MM-DD')
    groups << 'q=TEXT' if data_source.fulltext_fields.present?
    groups.compact.join('&')
  end

  def keys_map(fields_hash, default_value)
    fields_hash.keys.map { |key| "#{key}=#{default_value}" }.join('&') if fields_hash.present?
  end
end
