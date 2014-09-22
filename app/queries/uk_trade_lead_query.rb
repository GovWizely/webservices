class UkTradeLeadQuery < CountryIndustryQuery
  setup_query(
    q:      %i(description title procurement_organization),
    query:  %i(industry),
    filter: %i(),
    sort:   %i(publish_date),
  )
end
