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
            json.child! { json.range { json.end_date { json.gte Date.current } } }
            json.child! { json.terms { json.country @countries } } if @countries
          end
        end
      end
    end
  end
end
