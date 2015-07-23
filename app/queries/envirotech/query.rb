module Envirotech
  class Query < ::Query
    attr_reader :sources, :source_ids

    setup_query(q: %i(name_chinese
                      name_english
                      name_french
                      name_portuguese
                      name_spanish
                      abstract_chinese
                      abstract_english
                      abstract_french
                      abstract_portuguese
                      abstract_spanish
                      issue_id
                      provider_id
                      solution_id))

    def initialize(options = {})
      super
      @sources = options[:sources].try { |s| s.upcase.split(',') } || []
      @source_ids = options[:source_ids].try { |s| s.split(',') } || []
      @q = options[:q]
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.source_id @source_ids } } if @source_ids.any?
          end
        end
      end if @sources.any? || @source_ids.any?
    end
  end
end
