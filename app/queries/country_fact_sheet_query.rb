class CountryFactSheetQuery < Query
  setup_query(
    q:      %i(title official_name content_html full_html),
    query:  %i(full_html),
    filter: %i(),
    sort:   %i(),
  )

  def initialize(options = {})
    super
    @q = options[:q]
  end
end
