class ItaTaxonomySuggestionQuery
  def initialize(label)
    @label = label
  end

  def generate_search_body
    Jbuilder.encode do |json|
      generate_suggest json
    end
  end

  private

  def generate_suggest(json)
    json.suggestions do
      json.text @label
      json.completion do
        json.field 'label_suggest'
        json.size 10
      end
    end
  end
end