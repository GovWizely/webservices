module TradeEvent
  class Query < ::CountryIndustryQuery
    attr_reader :sources

    def initialize(options = {})
      super
      @sources = options[:sources].present? ? options[:sources].upcase.split(',') : []
      @sort = '_score,start_date'
    end

    private

    def generate_query(json)
      generate_multi_query(
        json,
        %i(
          registration_title description event_name industries city
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
          end
        end
      end if @sources.any? || @countries
    end
  end
end
