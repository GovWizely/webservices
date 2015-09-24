json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :description, :expiration_date, :industries, :ita_industries, :report_type, :title, :url)
    json.countries ((entry[:_source][:countries].nil? || entry[:_source][:countries].empty?) ? nil : entry[:_source][:countries])
  end
end
