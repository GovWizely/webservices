json.partial! 'shared/queryinfo'
json.results do
  json.partial! 'entries', entries: @search[:hits]
end
