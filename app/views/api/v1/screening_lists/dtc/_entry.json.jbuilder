json.call(entry[:_source],
          :alt_names,
          :remarks,
          :federal_register_notice,
          :name,
          :start_date,
          :source_list_url,
          :source_information_url,
)
json.source entry[:_source][:source][:full_name]
