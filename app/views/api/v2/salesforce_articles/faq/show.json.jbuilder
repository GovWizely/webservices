source_fields = [
  :first_published_date,
  :last_published_date,
  :url,
  :industries,
  :topics,
  :countries,
  :trade_regions,
  :world_regions,
]

entry = @search[:hits].first
json.id entry[:_id]
json.question(entry[:_source][:title])
json.answer(entry[:_source][:atom])
json.call(entry[:_source], *source_fields)
