json.call(@search, :total)
json.results do
  json.array! @search[:hits] do |hit|
    ita_office_location = hit.deep_symbolize_keys
    json.id ita_office_location[:_id]
    json.call(ita_office_location[:_source],
              :post, :office_name, :country, :state, :city, :address, :email, :fax, :mail_instructions, :phone, :post_type)
  end
end
