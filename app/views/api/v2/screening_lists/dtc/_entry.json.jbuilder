json.call(entry[:_source],
          :alt_names,
          :federal_register_notice,
          :name,
         )
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
         )
