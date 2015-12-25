module V2::TradeEvent
  class Query < ::CountryIndustryQuery
    #
    # NOTE: This is mostly duplicated code.
    #       Given the fact we'll remove V1 soon after V2 becomes default it might
    #       not make sense to work on unifying just now.
    #       ... I should know better. You can make fun of me when you read this comment
    #       years later.
    #
    attr_reader :sources
    aggregate_terms_by countries:  { field: 'venues.country' },
                       industries: { field: 'industries.keyword' },
                       sources:    { field: 'source' }

    def initialize(options = {})
      super
      @industries = options[:industries].split(',').map(&:strip) rescue nil
      @sources = options[:sources].upcase.split(',') rescue []
      @sort = '_score,start_date'
      @start_date = options[:start_date] if options[:start_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
      # Just to be sure, at this point, that no
      # filtering/sorting/scoring is being done on @industry
      @industry = nil
    end

    private

    def generate_query(json)
      json.query do
        json.filtered do
          filter_json(json)
          query_json(json)
        end
      end if @q || any_field_exist?
    end

    def query_json(json)
      multi_fields = %i(
        registration_title description event_name industries.keyword city
        venues.city venues.state venues.country
        contacts.first_name contacts.last_name contacts.person_title
      )
      json.query do
        json.bool do
          json.must do |must_json|
            must_json.child! { must_json.match { must_json.set! 'industries.tokenized', @industry } } if @industry
            must_json.child! { generate_multi_match(must_json, multi_fields, @q) }
          end
        end
      end if @q
    end

    def filter_json(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.set! 'venues.country', @countries } } if @countries
            generate_date_range(json, 'start_date', @start_date) if @start_date
            generate_date_range(json, 'end_date', @end_date) if @end_date
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
      end if any_field_exist?
    end

    def generate_filter(_json)
      nil
    end

    def any_field_exist?
      @sources.any? || @countries || @industries || @start_date || @end_date
    end
  end
end
