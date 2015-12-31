module V2::TradeEvent
  class UstdaQuery < V2::TradeEvent::Query
    MULTI_FIELDS = %i(
      registration_title description event_name
      venues.city venues.state venues.country
      first_name last_name person_title
    )
  end
end
