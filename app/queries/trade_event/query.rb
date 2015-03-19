module TradeEvent
  class Query < ::CountryIndustryQuery
    attr_reader :sources

    def initialize(options = {})
      super
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @sort = '_score,start_date'
      @start_date = options[:start_date] if options[:start_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
    end

    private

    def generate_query(json)
      multi_fields = %i(
        registration_title description event_name industries city
        venues.city venues.state venues.country
        contacts.first_name contacts.last_name contacts.person_title
      )
      json.query do
        json.bool do
          json.must do |must_json|
            must_json.child! { must_json.match { must_json.industries @industry } } if @industry
            must_json.child! { generate_multi_match(must_json, multi_fields, @q) } if @q
          end
        end
      end if @industry || @q
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.terms { json.source @sources } } if @sources.any?
            json.child! { json.terms { json.set! 'venues.country', @countries } } if @countries
            generate_date_range(json, 'start_date', @start_date) if @start_date
            generate_date_range(json, 'end_date', @end_date) if @end_date
          end
        end
      end if @sources.any? || @countries || @start_date || @end_date
    end
  end
end
