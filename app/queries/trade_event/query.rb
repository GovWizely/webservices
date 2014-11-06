module TradeEvent
  class Query < ::CountryIndustryQuery
    attr_reader :sources

    def initialize(options)
      super(options)
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
            json.child! do
              json.bool do
                json.set! :should do
                  json.child! { json.terms { json.country @countries } }
                  json.child! { json.query { json.match { json.set! 'venues.country', @countries.map(&:strip).join(' ') } } }
                end
              end
            end 
          end
        end
      end if @countries
    end
  end
end
