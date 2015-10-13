class CountryFactSheetQuery < Query
  def initialize(options = {})
    super
    @q = options[:q] if options[:q].present?
    @countries = options[:countries].downcase.split(',') if options[:countries].present?
    @sources = options[:sources].downcase.split(',') if options[:sources].present?
    @topics = options[:topics].downcase.split(',') if options[:topics].present?
  end

  def generate_query(json)
    multi_fields = %i(title content_html)
    json.query do
      json.bool do
        json.must do
          json.child! { generate_multi_match(json, multi_fields, @q) }
        end
      end
    end if @q
  end

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.country @countries } } if @countries
          json.child! { json.terms { json.source @sources } } if @sources
          json.child! { json.terms { json.topic @topics } } if @topics
        end
      end
    end if @countries || @sources || @topics
  end
end
