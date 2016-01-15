class BusinessServiceProviderQuery < Query
  setup_query(
    q:      %i(company_description company_name contact_name),
    query:  %i(),
    filter: %i(ita_office category),
    sort:   %i(),
  )

  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
    @ita_office = options[:ita_offices].downcase.split(',') if options[:ita_offices].present?
    @category = options[:categories].downcase.split(',') if options[:categories].present?
  end

  def filter_from_fields_child(json, field, search)
    generate_terms(json, field, search)
  end
end
