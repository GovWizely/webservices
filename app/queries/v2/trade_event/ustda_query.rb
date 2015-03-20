module V2::TradeEvent
  class UstdaQuery < V2::TradeEvent::Query
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
  end
end
