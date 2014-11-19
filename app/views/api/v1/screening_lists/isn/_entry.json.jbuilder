json.call(entry[:_source],
          :federal_register_notice,
          :name,
          :programs,
)
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
          :start_date,
)
