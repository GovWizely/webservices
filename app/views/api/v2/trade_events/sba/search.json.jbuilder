json.partial! 'shared/queryinfo'
json.results do
  json.partial! 'api/v2/trade_events/consolidated/entries', entries: @search[:hits], source: :sba
end
