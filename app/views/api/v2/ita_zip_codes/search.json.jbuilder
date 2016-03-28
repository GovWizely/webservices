json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    ita_zip_code = hit.deep_symbolize_keys

    json.id hit[:_id]
    json.call(ita_zip_code[:_source],
              :zip_code, :zip_city, :post, :office_name, :country, :state, :post_city,
              :address, :email, :fax, :mail_instructions, :phone,)
  end
end
