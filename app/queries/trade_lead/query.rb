module TradeLead
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @q = options[:q] if options[:q].present?
      @countries = options[:countries].upcase.split(',') if options[:countries].present?
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @industry = options[:industries] if options[:industries].present?
      @sort = @q ? '_score' : 'publish_date:desc,country:asc'
    end

    private

    def generate_query(json)
      multi_fields = %i(title description topic tags procurement_organization)
      json.query do
        json.bool do
          json.must do
            json.child! { json.match { json.industry @industry } }        if @industry
            json.child! { generate_multi_match(json, multi_fields, @q) }  if @q
          end
        end
      end if @q || @industry
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.country @countries } } if @countries
          end
        end
      end if @countries || @sources.any?
    end
  end
end
