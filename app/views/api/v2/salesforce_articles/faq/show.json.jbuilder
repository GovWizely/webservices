source_fields = [
  :question,
  :answer,
  :summary,
  :first_published_date,
  :last_published_date,
  :public_url,
  :references,
  :url_name,
  :industries,
  :topics,
  :countries,
  :trade_regions,
  :world_regions,
]

entry = @search[:hits].first
json.id entry[:_id]
json.call(entry[:_source], *source_fields)
