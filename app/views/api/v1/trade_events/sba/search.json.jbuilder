json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    sba_trade_event = hit.deep_symbolize_keys
    json.partial! 'entry', entry: sba_trade_event
  end
end
