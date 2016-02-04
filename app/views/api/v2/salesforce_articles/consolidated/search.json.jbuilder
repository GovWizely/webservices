json.partial! 'shared/queryinfo'
json.partial! 'shared/aggregation'
json.results do
  json.partial! 'entries', entries: @search[:hits]
end
