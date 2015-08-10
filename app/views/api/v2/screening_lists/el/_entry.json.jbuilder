json.partial! 'api/v2/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :federal_register_notice,
          :license_policy,
          :license_requirement,
          :name,
          :title,
         )
json.source entry[:_source][:source][:full_name]
json.call(entry[:_source],
          :source_information_url,
          :source_list_url,
          :standard_order,
          :start_date,
         )
