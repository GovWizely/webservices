json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v1/trade_events/#{entry[:_source][:source].downcase}/entry", entry: entry
  end
end
