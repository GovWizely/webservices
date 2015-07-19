module Envirotech
  class Query < ::Query
    attr_reader :sources

    setup_query(q: %i(name_chinese
                      name_english
                      name_french
                      name_portuguese
                      name_spanish
                      abstract_chinese
                      abstract_english
                      abstract_french
                      abstract_portuguese
                      abstract_spanish))

    def initialize(options = {})
      super
      @sources = options[:sources].try { |s| s.upcase.split(',') } || []
      @q = options[:q]
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } }
          end
        end
      end if @sources.any?
    end
  end
end
