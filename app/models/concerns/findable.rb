module Findable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_by_id(id)
      query = ::IdQuery.new id
      search_options = {
        index: index_names,
        body:  query.generate_search_body,
      }

      results = ES.client.search search_options
      hits = results['hits']
      hits.deep_symbolize_keys
    end
  end
end
