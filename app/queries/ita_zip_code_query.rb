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
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.zip_code @zip_codes } } if @zip_codes
        end
      end
    end if @zip_codes
  end
end
