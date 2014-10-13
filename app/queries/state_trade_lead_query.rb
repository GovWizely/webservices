class StateTradeLeadQuery < CountryIndustryQuery
  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
    @specific_location = options[:specific_location] if options[:specific_location].present?
    @sort = :publish_date
  end

  private

  def generate_query(json)
    multi_fields = %i(description title tags procurement_organization)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.industry @industry } } if @industry
          must_json.child! { must_json.match { must_json.specific_location @specific_location } } if @specific_location
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @industry || @specific_location || @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
        end
      end
    end if @countries
  end
end
