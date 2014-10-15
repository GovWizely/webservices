json.partial! 'api/v1/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :entity_number,
          :federal_register_notice,
          :license_requirement,
          :license_policy,
          :name,
          :programs,
          :standard_order,
          :start_date,
          :end_date,
          :type,
          :source_list_url,
          :source_information_url,
          :title,
)
json.source entry[:_source][:source][:full_name]
