module ItaTaxonomySuggestion
  def self.search_for(options)
    query = ItaTaxonomySuggestionQuery.new options[:label]
    results = ES.client.suggest(build_search_options(query))
    results['suggestions'].first['options'].map { |s| s['text'] }
  end

  module ClassMethods
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
