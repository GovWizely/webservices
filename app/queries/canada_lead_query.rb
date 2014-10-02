class CanadaLeadQuery < Query
  setup_query(
    q:      %i(title description),
    query:  %i(),
    filter: %i(industry specific_location),
    sort:   %i(end_date publish_date title.raw contract_number),
  )
end
