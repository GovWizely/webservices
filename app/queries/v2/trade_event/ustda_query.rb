module V2::TradeEvent
  class UstdaQuery < V2::TradeEvent::Query
    def initialize(options = {})
      super
      @multi_fields = [
        :registration_title, :description, :event_name, :'venues.city',
        :'venues.state', :'venues.country', :first_name,
        :last_name, :person_title
      ]
    end
  end
end
