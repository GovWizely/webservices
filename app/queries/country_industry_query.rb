class CountryIndustryQuery < Query
  attr_reader :countries

  def initialize(options = {})
    super
    if options[:countries].present?
      @countries = options[:countries].upcase.split(',').map(&:strip)
    end
    @industry = options[:industry] if options[:industry].present?
    @q = options[:q] if options[:q].present?
  end

  private

  def generate_multi_query(json, multi_fields)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.industries @industry } } if @industry
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @industry || @q
  end
end
