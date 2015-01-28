json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! 'api/v1/tariff_rates/tariff_entry', entry: entry
  end
end
