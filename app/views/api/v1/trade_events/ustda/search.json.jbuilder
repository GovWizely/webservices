json.call(@search, :total, :offset)
json.results do
  json.partial! 'api/v1/trade_events/consolidated/entries', entries: @search[:hits], source: :ustda
end
