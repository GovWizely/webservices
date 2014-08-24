json.(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    trade_event = hit.deep_symbolize_keys
    json.id trade_event[:_id]
    json.(trade_event[:_source],
        :event_name, :event_type, :start_date, :end_date, :cost,
        :registration_link, :registration_title, :description,
        :industries, :url, :venue, :city, :state, :country, :contacts)
  end
end
