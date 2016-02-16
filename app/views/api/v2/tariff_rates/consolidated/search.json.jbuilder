json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id hit[:_id]
    json.partial! 'api/v2/tariff_rates/tariff_entry', entry: entry
  end
end
