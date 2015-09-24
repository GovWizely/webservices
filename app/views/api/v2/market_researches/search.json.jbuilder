json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :countries, :description, :expiration_date, :industries, :ita_industries, :report_type, :title, :url)
  end
end
