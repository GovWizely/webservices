json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v2/envirotech/#{entry[:_source][:source].singularize.underscore}/entry", entry: entry
  end
end
