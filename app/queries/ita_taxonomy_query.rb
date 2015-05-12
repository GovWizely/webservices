class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
    @taxonomies = options[:taxonomies].downcase.split(',') if options[:taxonomies].present?
  end

  private

  def generate_filter(json)
    json.filter do
      json.bool do
        json.must do
          json.child! { json.terms { json.taxonomy @taxonomies } } if @taxonomies
        end
      end
    end if @taxonomies
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
