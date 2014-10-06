module TradeEvent
  class UstdaQuery < Query #CountryIndustryQuery
    def initialize(options)
      super
      @sort = :start_date unless @q
    end

    private

    def generate_query(json)
      generate_multi_query json, [:description, :event_name]
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.range { json.end_date { json.gte Date.current } } }
            json.child! { json.terms { json.set! 'venues.country', @countries.map(&:strip) } } if @countries
          end
        end
      end
    end
  end
end
