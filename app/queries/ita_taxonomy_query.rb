class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
    @taxonomies = options[:taxonomies].downcase.split(',') if options[:taxonomies].present?
    @parent_names = options[:parent_names].downcase.split(',') if options[:parent_names].present?
  end

  private

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.taxonomy @taxonomies } } if @taxonomies
          json.child! { json.terms { json.parent_names @parent_names } } if @parent_names
        end
      end
    end if @taxonomies || @parent_names
  end

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          json.child! do
            generate_multi_match(json, %w(name parent_names), @q)
          end if @q
        end
      end
    end if @q
  end
end
