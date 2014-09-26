json.id entry[:_id]
json.call(entry[:_source], :country, :reference_number, :publish_date, :min_contract_value, :max_contract_value,
          :status, :url, :procurement_organization, :contact, :title, :description, :notice_type,
          :industry, :specific_location)
