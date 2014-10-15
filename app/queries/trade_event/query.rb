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
      generate_multi_query json, %i(event_name registration_title description industries city)
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! do
              json.range { json.end_date { json.gte Date.current } }
            end
            json.child! do
              json.bool do
                json.set! :should do
                  json.child! { json.terms { json.country @countries } }
                  json.child! { json.query { json.match { json.set! 'venues.country', @countries.map(&:strip).join(' ') } } }
                end
              end
            end if @countries
          end
        end
      end
    end
  end
end
