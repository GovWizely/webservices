module TradeLead
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @countries = begin
                     options[:countries].upcase.split(',')
                   rescue
                     nil
                   end
      @sources   = begin
                     options[:sources].upcase.split(',')
                   rescue
                     []
                   end
      @industry  = options[:industries]
      @q    = options[:q]
      @sort = @q ? '_score' : 'publish_date:desc,country:asc'

      @publish_date = options[:publish_date] if options[:publish_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
      @publish_date_amended = options[:publish_date_amended] if options[:publish_date_amended].present?
    end

    private

    def generate_query(json)
      multi_fields = %i(title description industry tags procurement_organization)
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
            generate_date_range(json, 'publish_date', @publish_date) if @publish_date
            generate_date_range(json, 'publish_date_amended', @publish_date_amended) if @publish_date_amended
            generate_date_range(json, 'end_date', @end_date) if @end_date
          end
        end
      end if @countries || @sources.any? || @publish_date || @end_date || @publish_date_amended
    end
  end
end
