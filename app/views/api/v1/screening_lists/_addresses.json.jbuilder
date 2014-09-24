json.addresses do
  json.array! addresses do |address|
    json.(address.deep_symbolize_keys,
      :address,
      :city,
      :state,
      :postal_code,
      :country,
    )
  end
end
