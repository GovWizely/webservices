json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :agency, :contract_value, :description, :parent_id, :procurement_method, :publish_date_amended, :status, :topic, :url)
  end
end
