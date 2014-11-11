json.call(@search, :total, :offset)
json.results do
  json.partial! 'entries', entries: @search[:hits]
end
