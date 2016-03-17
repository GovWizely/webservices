class ItaTaxonomyQuery < Query
  def initialize(options = {})
    super
    @q = options[:q].downcase if options[:q].present?
  end

  private

  def generate_filter(_json)
  end

  def generate_query(json)
    json.query do
      json.bool do
        json.must do
          generate_match(json, 'label.tokenized', @q)
        end
      end
    end if @q
  end
end
