class EccnQuery < Query
  setup_query(
    q:      %i(description eccn0 eccn1 eccn2 eccn3 eccn4 url0 url1 url2),
    query:  %i(description),
    filter: %i(),
    sort:   %i(),
  )

  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
  end
end
