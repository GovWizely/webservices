module V2::TradeLead
  class Query < ::Query
    attr_reader :countries, :sources
    aggregate_terms_by countries: { field: 'country' },
                       sources:   { field: 'source' }

    MULTI_FIELDS = %i(title description industry.tokenized ita_industries.tokenized tags procurement_organization)

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
      json.query do
        json.filtered do
          generate_filtered(json)
          json.query do
            json.bool do
              json.must do
                json.child! { generate_multi_match(json, self.class::MULTI_FIELDS, @q) }
              end
            end
          end if @q
        end
      end if @q || any_field_exist?
    end

    def generate_filtered(json)
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

    def generate_filter(_json)
      nil
    end

    def any_field_exist?
      @countries || @sources.any? || @industries || @publish_date || @end_date || @publish_date_amended
    end

    def generate_industries_filter(json)
      json.child! do
        json.bool do
          json.set! 'should' do
            Array(@industries).each do |ind|
              industry_match(json, 'industry.keyword', ind)
              industry_match(json, 'ita_industries.keyword', ind)
            end
          end
        end
      end if @industries
    end

    def industry_match(json, field, industry)
      json.child! do
        json.query { json.match { json.set! field, industry } }
      end
    end
  end
end
