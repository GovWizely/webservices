class FbopenLeadQuery < Query

  setup_query(
    q: %i(title description),
    query: %i(),
    filter: %i(industry specific_location),
    sort: %i(end_date contract_number),
  )


  private

  def generate_query(json)
    query_from_fields(
      json,
      my_query_fields
    )
  end

  def generate_filter(json)
    filter_from_fields(
      json,
      my_filter_fields
    )
  end
end
