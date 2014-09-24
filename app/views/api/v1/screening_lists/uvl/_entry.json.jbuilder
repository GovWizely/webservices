json.partial! "api/v1/screening_lists/addresses",
  addresses: entry[:_source][:addresses]
json.(entry[:_source],
  :alt_names,
  :name,
  :source,
  :source_list_url,
)
