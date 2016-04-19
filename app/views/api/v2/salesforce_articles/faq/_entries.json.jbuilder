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

json.array! entries do |hit|
  entry = hit.deep_symbolize_keys
  src_name = (local_assigns[:source] ? source : entry[:_source][:source].downcase.to_sym)
  json.id(entry[:_id])
  json.question(entry[:_source][:title])
  json.answer(entry[:_source][:atom])
  json.call(entry[:_source], *source_fields)
end
