json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    ita_trade_event = hit.deep_symbolize_keys
    json.partial! 'entry', entry: ita_trade_event
  end
end
