json.partial! 'api/v2/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :citizenships,
          :dates_of_birth,
          :entity_number,
          :ids,
          :name,
          :nationalities,
          :places_of_birth,
          :programs,
          :remarks,)
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
          :title,
          :type,)
