class FbopenLeadQuery < Query
  query_fields %i(  title description industry specific_location q  )

  def initialize(options)
    super(options)
    @sort = 'end_date,contract_number' unless @q
  end

  private

  def generate_query(json)
    query_from_fields(
      json,
      q:          %i(title description),
    )
  end

  def generate_filter(json)
    filter_from_fields(
      json,
      searchable: %i(industry specific_location),
    )
  end
end
