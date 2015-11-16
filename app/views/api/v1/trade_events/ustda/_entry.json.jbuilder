json.id(entry[:_id])
json.call(entry[:_source],
          :event_name, :start_date, :end_date, :start_time, :end_time, :cost,
          :cost_currency, :registration_link, :registration_title,
          :description, :industries, :url, :venues, :first_name, :last_name,
          :post, :person_title, :phone, :email, :source, :event_type
         )
