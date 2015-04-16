module V2::TradeLead
  class Query < ::Query
    attr_reader :countries, :sources

    def initialize(options = {})
      super
      @countries = options[:countries].upcase.split(',') if options[:countries].present?
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @industries = options[:industries].split(',').map(&:strip) if options[:industries].present?
      @q = options[:q]
      @sort = @q ? '_score' : 'publish_date:desc,country:asc'
      @publish_date = options[:publish_date] if options[:publish_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
      @publish_date_amended = options[:publish_date_amended] if options[:publish_date_amended].present?
    end

    private

    def generate_query(json)
      multi_fields = %i(title description topic tags procurement_organization)
      json.query do
        json.bool do
          json.must do
            json.child! { generate_multi_match(json, multi_fields, @q) }
          end
        end
      end if @q
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
            generate_industries_filter(json)
          end
        end
      end if any_field_exist?
    end

    def any_field_exist?
      @countries || @sources.any? || @industries || @publish_date || @end_date || @publish_date_amended
    end

    def generate_industries_filter(json)
      json.child! do
        json.bool do
          json.set! 'should' do
            Array(@industries).each do |ind|
              json.child! do
                json.query { json.match { json.set! 'industry.keyword', ind } }
              end
            end
          end
        end
      end if @industries
    end
  end
end
