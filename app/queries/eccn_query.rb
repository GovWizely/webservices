class EccnQuery < Query
  setup_query(
    q:      %i(description eccn0 eccn1 eccn2 eccn3 eccn4),
    query:  %i(),
    filter: %i(),
    sort:   %i(),
  )

  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
  end
end
