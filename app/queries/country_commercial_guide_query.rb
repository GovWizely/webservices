class CountryCommercialGuideQuery < Query
  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
  end

  private

  def generate_query(json)
    multi_fields = %i(title section content)
    json.query do
      json.bool do
        json.must do
          json.child! { generate_multi_match(json, multi_fields, @q) } if @q
        end
      end
    end if @q
  end

  def generate_filter(_json)
  end
end
