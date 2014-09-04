json.partial! "api/v1/consolidated_screening_entries/addresses",
  addresses: entry[:_source][:addresses]
json.(entry[:_source],
  :alt_names,
  :name,
  :source,
)
