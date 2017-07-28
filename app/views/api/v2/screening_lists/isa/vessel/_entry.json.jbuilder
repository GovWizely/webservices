json.partial! 'api/v2/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :call_sign,
          :entity_number,
          :gross_registered_tonnage,
          :gross_tonnage,
          :ids,
          :name,
          :programs,
          :remarks,
         )
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
          :title,
          :type,
          :vessel_flag,
          :vessel_owner,
          :vessel_type,
         )
