json.partial! 'api/v1/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :alt_names,
          :federal_register_notice,
          :license_requirement,
          :license_policy,
          :name,
          :standard_order,
          :start_date,
          :source_list_url,
          :source_information_url,
)
json.source entry[:_source][:source][:full_name]
