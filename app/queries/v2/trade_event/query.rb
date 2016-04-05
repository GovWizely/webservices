module V2::TradeEvent
  class Query < ::CountryIndustryQuery
    include ParsedQueryMethods
    #
    # NOTE: This is mostly duplicated code.
    #       Given the fact we'll remove V1 soon after V2 becomes default it might
    #       not make sense to work on unifying just now.
    #       ... I should know better. You can make fun of me when you read this comment
    #       years later.
    #
    attr_reader :sources
    aggregate_terms_by countries:     { field: 'venues.country' },
                       sources:       { field: 'source' },
                       trade_regions: { field: 'trade_regions' },
                       world_regions: { field: 'world_regions' }

    MULTI_FIELDS = %i(
      registration_title description event_name industries.keyword city
      venues.city venues.state venues.country
      contacts.first_name contacts.last_name contacts.person_title
    )

    def initialize(options = {})
      super
      @sources = begin
                   options[:sources].upcase.split(',')
                 rescue
                   []
                 end
      @sort = '_score,start_date'
      @start_date = options[:start_date] if options[:start_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
      @industries = split_to_array(options[:industries]) if options[:industries].present?
      # Just to be sure, at this point, that no
      # filtering/sorting/scoring is being done on @industry
      @industry = nil

      set_geo_instance_variables(options)
      update_instance_variables(QueryParser.parse(@q)) unless @q.nil?
    end

    private

    def generate_query(json)
      json.query do
        json.filtered do
          generate_filtered(json)
          generate_parsed_query(json, 'venues.country_name')
        end
      end
    end

    def generate_filtered(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            generate_date_range(json, 'start_date', @start_date) if @start_date
            generate_date_range(json, 'end_date', @end_date) if @end_date
            generate_industries_filter(json)
            generate_geo_filters(json, 'venues.country')
          end
        end
      end if any_field_exist?
    end

    def generate_filter(_json)
      nil
    end

    def any_field_exist?
      @sources.any? || @countries || @industries || @start_date || @end_date || @trade_regions || @world_regions
    end

    def generate_industries_filter(json)
      json.child! do
        json.bool do
          json.set! 'should' do
            Array(@industries).each do |ind|
              json.child! do
                json.query { json.match { json.set! 'industries.keyword', ind } }
              end
            end
          end
        end
      end if @industries
    end
  end
end
