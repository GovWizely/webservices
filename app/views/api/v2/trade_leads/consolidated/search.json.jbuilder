json.partial! 'shared/queryinfo'
json.partial! 'shared/aggregation'
json.results do
  json.array! @search[:hits] do |entry|
    json.partial! 'entry', entry: entry
  end
end
