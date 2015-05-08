json.id(entry[:_id])
json.call(entry[:_source],
          :event_name,
          :description,
          :url,
          :source,
         )
