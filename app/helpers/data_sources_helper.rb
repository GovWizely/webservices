module DataSourcesHelper
  def sample_api_call(data_source)
    url = "/v#{data_source.version_number}/#{data_source.api}/search.json?api_key=#{current_user.api_key}"
    link_to url, url
  end

  def param_table(field_hash)
    content_tag(:dl, class: 'dl-horizontal') do
      field_hash.each do |field, hash|
        concat content_tag(:dt, field)
        concat content_tag(:dd, hash.attributes[:description])
      end
    end
  end
end
