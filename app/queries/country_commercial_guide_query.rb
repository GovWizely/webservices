class CountryCommercialGuideQuery < Query
  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
    @countries = options[:countries].downcase.split(',') if options[:countries].present?
    @topics = options[:topics].downcase.split(',') if options[:topics].present?
  end

  private

  def generate_query(json)
    multi_fields = %i(title chapter section content)
    json.query do
      json.bool do
        json.must do
          json.child! { generate_multi_match(json, multi_fields, @q) } if @q
        end
      end
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
          json.child! { json.terms  { json.topics @topics }  } if @topics
        end
      end
    end if @countries ||  @topics
  end
end
