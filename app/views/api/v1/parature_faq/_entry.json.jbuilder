json.id entry[:_id]
json.call(entry[:_source],
          :question, :answer, :update_date, :topic, :industry, :country
         )
