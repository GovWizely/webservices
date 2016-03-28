class CountryIndustryQuery < Query
  attr_reader :countries

  def initialize(options = {})
    super
    @countries = begin
                   options[:countries].upcase.split(',').map(&:strip)
                 rescue
                   nil
                 end
    @industry = options[:industry]
    @q = options[:q]
  end

  private

  def generate_multi_query(json, multi_fields)
    json.query do
      json.bool do
        json.must do |must_json|
          must_json.child! { must_json.match { must_json.set! 'industries.tokenized', @industry } } if @industry
          must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
        end
      end
    end if @industry || @q
  end
end
