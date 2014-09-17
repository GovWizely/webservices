class UkTradeLeadQuery < CountryIndustryQuery
  query_fields %i(  description title procurement_organization countries industry q  )

  def initialize(options = {})
    super options
    @sort = :publish_date
  end

  private

  def generate_query(json)
    query_from_fields(
      json,
      searchable: %i(industry),
      q:          %i(description title procurement_organization),
    )
  end

  def generate_filter(_json)
  end
end
