json.call(entry[:_source],
          :federal_register_notice,
          :name,
          :alt_names,
          :country,
          :programs,
          :remarks,
         )
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
          :start_date,
         )
