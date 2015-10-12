module DataSourcesHelper
  def sample_api_call(data_source)
    groups = ["api_key=#{current_user.api_key}"]
    groups << data_source.filter_fields.keys.map { |key| "#{key}=VALUE" }.join('&') if data_source.filter_fields.present?
    groups << data_source.date_fields.keys.map { |key| "#{key}=YYYY-MM-DD+TO+YYYY-MM-DD" }.join('&') if data_source.date_fields.present?
    groups << "q=TEXT" if data_source.fulltext_fields.present?
    url = "/#{data_source.api}/search.json?#{groups.join('&')}"
    link_to url, url
  end

  def param_table(field_description_hash)
    content_tag(:dl, class: 'dl-horizontal' ) do
      field_description_hash.each do |field, description|
        concat content_tag(:dt, field)
        concat content_tag(:dd, description)
      end
    end
  end
end
