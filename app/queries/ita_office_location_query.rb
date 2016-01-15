class ItaOfficeLocationQuery < Query
  setup_query(
    q:      %i(post office_name),
    query:  %i(city),
    filter: %i(country state),
    sort:   %i(post.sort),
  )

  def initialize(options = {})
    super
    @country = options[:countries].downcase.split(',') if options[:countries]
    @state = options[:state].downcase.split(',') if options[:state]
  end

  def filter_from_fields_child(json, field, search)
    generate_terms(json, field, search)
  end
end
