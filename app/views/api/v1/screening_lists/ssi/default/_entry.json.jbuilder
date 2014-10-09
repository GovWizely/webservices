json.partial! 'api/v1/screening_lists/addresses',
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
          :remarks,
          :type,
          :source,
          :source_list_url,
          :title,
)