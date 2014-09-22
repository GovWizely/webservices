class ItaOfficeLocationQuery < Query
  setup_query(
    q:      %i(post office_name),
    query:  %i(city),
    filter: %i(country state),
    sort:   %i(post.sort),
  )
end
