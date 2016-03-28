class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
    @types = split_to_array(options[:types].downcase) if options[:types].present?
    @labels = split_to_array(options[:labels].downcase) if options[:labels].present?
  end

  private

  def generate_filter(json)
    terms_filter_from_field_mapping(json, type: @types, 'label.keyword' => @labels)
  end

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! { generate_match(json, 'label.tokenized', @q, :or) }
        end
      end
    end if @q
  end
end
