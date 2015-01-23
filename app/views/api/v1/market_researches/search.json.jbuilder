json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :description, :expiration_date, :report_type, :title, :url)
    json.countries ((entry[:_source][:countries].nil? || entry[:_source][:countries].empty?) ? nil : entry[:_source][:countries])
    json.industries (entry[:_source][:industries][:original].empty? ? nil : entry[:_source][:industries][:original])
  end
end
