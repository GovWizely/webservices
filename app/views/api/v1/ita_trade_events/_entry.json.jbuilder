json.id(entry[:_id])
json.call(entry[:_source],
          :event_name,
          :event_type,
          :start_date,
          :end_date,
          :cost,
          :registration_link,
          :registration_title,
          :description,
          :industries,
          :url,
          :venue,
          :city,
          :state,
          :country,
          :contacts,
)
