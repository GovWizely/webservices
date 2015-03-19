module TradeEvent
  class Query < ::CountryIndustryQuery
    attr_reader :sources

    def initialize(options = {})
      super
      @sources = options[:sources].upcase.split(',') rescue []
      @sort = '_score,start_date'
      @start_date = options[:start_date] if options[:start_date].present?
      @end_date = options[:end_date] if options[:end_date].present?
    end

    private

    def generate_query(json)
      generate_multi_query(
        json,
        %i(
          registration_title description event_name industries.tokenized city
          venues.city venues.state venues.country
          contacts.first_name contacts.last_name contacts.person_title
        ),
      )
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
