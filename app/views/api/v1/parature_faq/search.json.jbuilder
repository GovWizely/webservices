json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! 'entry', entry: entry
  end
end
