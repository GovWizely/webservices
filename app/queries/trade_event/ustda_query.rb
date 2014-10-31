module TradeEvent
  class UstdaQuery < TradeEvent::Query
    private

    def generate_query(json)
      generate_multi_query(
        json,
        [
          :registration_title, :description, :event_name, :'venues.city',
          :'venues.state', :'venues.country', :'contacts.first_name',
          :'contacts.last_name', :'contacts.person_title'
        ],
      )
    end

    def generate_filter(json)
      json.filter do
        json.bool do
          json.must do
            json.child! { json.range { json.end_date { json.gte Date.current } } }
            json.child! { json.query { json.match { json.set! 'venues.country', @countries.map(&:strip).join(' ') } } } if @countries
          end
        end
      end
    end
  end
end
