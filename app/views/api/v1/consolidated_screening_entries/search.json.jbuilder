json.(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v1/#{entry[:_type].pluralize}/entry", entry: entry
  end
end
