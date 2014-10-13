class FbopenLeadQuery < Query
  setup_query(
    q:      %i(title description),
    query:  %i(),
    filter: %i(industry specific_location),
    sort:   %i(end_date contract_number),
  )
end
