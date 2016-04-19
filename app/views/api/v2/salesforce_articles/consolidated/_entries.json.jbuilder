source_fields = [
  :source,
  :title,
  :summary,
  :first_published_date,
  :last_published_date,
  :url,
  :references,
  :url_name,
  :industries,
  :topics,
  :countries,
  :trade_regions,
  :world_regions,
]

json.array! entries do |hit|
  entry = hit.deep_symbolize_keys
  src_name = (local_assigns[:source] ? source : entry[:_source][:source].downcase.to_sym)
  json.id(entry[:_id])
  json.call(entry[:_source], *source_fields)
end
