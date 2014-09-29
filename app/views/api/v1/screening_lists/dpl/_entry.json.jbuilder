json.partial! 'api/v1/screening_lists/addresses',
              addresses: entry[:_source][:addresses]
json.call(entry[:_source],
          :end_date,
          :federal_register_notice,
          :name,
          :remarks,
          :standard_order,
          :start_date,
          :source,
          :source_list_url,
)
