module ItaTaxonomySuggestion
  def self.search_for(options)
    query = ItaTaxonomySuggestionQuery.new options
    results = ES.client.suggest(build_search_options(query))
    results['suggestions'].first['options'].map { |s| s['text'] }
  end

  module ClassMethods
    private

    def build_search_options(query)
      {
        index: ItaTaxonomy.index_name,
        type:  ItaTaxonomy.index_name.typeize,
        body:  query.generate_search_body,
      }
    end
  end

  extend ClassMethods
end
