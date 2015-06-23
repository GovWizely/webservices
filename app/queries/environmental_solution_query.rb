class EnvironmentalSolutionQuery < Query
  setup_query(q: %i(name_chinese name_english name_french name_portuguese name_spanish))

  def initialize(options = {})
    super
    @q = options[:q]
  end
end
