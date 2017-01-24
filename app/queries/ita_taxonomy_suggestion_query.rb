class ItaTaxonomySuggestionQuery
  VALID_SIZE_RANGE = 1..10
  DEFAULT_SIZE = 5

  def initialize(options)
    @term = options[:term]
    @size = begin
              options[:size].to_i
            rescue
              DEFAULT_SIZE
            end
    @size = DEFAULT_SIZE unless VALID_SIZE_RANGE.include?(@size)
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_suggest json
    end
  end

  private

  def generate_suggest(json)
    json.suggestions do
      json.text @term
      json.completion do
        json.field 'label_suggest'
        json.size @size
      end
    end
  end
end
