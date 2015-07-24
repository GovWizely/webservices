module Envirotech
  class Query < ::Query
    attr_reader :sources, :source_ids, :issue_ids, :provider_ids, :solution_ids

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
      @source_ids = options[:source_ids].try { |s| s.split(',') } || []
      @issue_ids  = options[:issue_ids].try { |s| s.split(',') } || []
      @provider_ids = options[:provider_ids].try { |s| s.split(',') } || []
      @solution_ids = options[:solution_ids].try { |s| s.split(',') } || []
      @q = options[:q]
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.source_id @source_ids } } if @source_ids.any?
            json.child! { json.terms { json.issue_id @issue_ids } } if @issue_ids.any?
            json.child! { json.terms { json.provider_id @provider_ids } } if @provider_ids.any?
            json.child! { json.terms { json.solution_id @solution_ids } } if @solution_ids.any?
          end
        end
      end if any_field_exist?
    end

    private

    def any_field_exist?
      @sources.any? || @source_ids.any? || @issue_ids.any? || @provider_ids.any? || @solution_ids.any?
    end
  end
end
