json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.type entry[:_type]
    json.partial! "api/v2/#{entry[:_type]}s/entry", entry: entry
  end
end
