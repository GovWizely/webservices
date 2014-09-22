class UkTradeLeadQuery < CountryIndustryQuery
  setup_query(
    q:      %i(description title procurement_organization),
    query:  %i(industry),
    filter: %i(),
    sort:   %i(publish_date),
  )

  def initialize(options = {})
    super options
    @sort = :publish_date
  end

end
