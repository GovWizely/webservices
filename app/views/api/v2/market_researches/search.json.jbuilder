json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :countries, :description, :expiration_date, :industries, :report_type, :title, :url)
  end
end
