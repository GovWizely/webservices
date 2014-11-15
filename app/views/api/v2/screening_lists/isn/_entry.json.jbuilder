json.call(entry[:_source],
          :federal_register_notice,
          :name,
          :programs,
          :start_date,
          :source_list_url,
          :source_information_url,
)
json.source entry[:_source][:source][:full_name]
