class UkTradeLeadQuery < CountryIndustryQuery

  def initialize(options={})
    super options
    @q = options[:q] if options[:q].present?
    @sort = :publish_date
  end

  private

  def generate_query(json)
     multi_fields = %i(description title procurement_organization)
     json.query do
       json.bool do
         json.must do |must_json|
           must_json.child! { must_json.match { must_json.industry @industry } } if @industry
           must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
         end
       end
     end if @industry || @q
  end

  def generate_filter(json)
  end
end
