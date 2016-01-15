class ItaZipCodeQuery < Query
  def initialize(options)
    super
    @zip_codes = options[:zip_codes].downcase.split(',') if options[:zip_codes].present?
    @q = options[:q].downcase if options[:q].present?
    @sort = '_score,zip_code:asc'
    @search_type = :dfs_query_then_fetch
  end

  def generate_query(json)
    multi_fields = %i(post office_name zip_city)
    generate_multi_match_query(json, multi_fields, @q)
  end

  def generate_filter(json)
    terms_filter_from_field_mapping(json, zip_code: @zip_codes)
  end
end
