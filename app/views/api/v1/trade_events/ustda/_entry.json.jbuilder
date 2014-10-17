json.id entry[:_id]
json.call(entry[:_source],
          :event_name, :event_type, :start_date, :end_date, :cost,
          :cost_currency, :registration_link, :registration_title,
          :description, :industries, :url, :venues, :contacts,
          :source)
