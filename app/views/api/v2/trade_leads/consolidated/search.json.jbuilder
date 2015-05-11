field_lists = {
  australia: [:agency, :contract_value, :description, :parent_id, :procurement_method, :publish_date_amended, :status, :topic, :url, :source],
  canada:    [:country, :title, :reference_number, :contract_number, :publish_date, :end_date,
              :publish_date_amended, :status, :industry,
              :specific_location, :notice_type, :trade_agreement, :bid_type,
              :competitive_procurement_strategy, :non_competitive_procurement_strategy,
              :procurement_organization, :implementing_entity, :description, :contact, :urls, :source],
  fbo:       [:notice_type, :publish_date, :procurement_organization, :procurement_office,
              :procurement_organization_address, :classification_code, :industry,
              :procurement_office_address, :title, :contract_number, :end_date, :contact,
              :description, :competitive_procurement_strategy, :url, :specific_location,
              :specific_address, :source],
  state:     [:lead_source, :country, :specific_location, :title,
              :project_number, :industry, :project_size, :description, :tags,
              :publish_date, :end_date, :funding_source, :borrowing_entity,
              :procurement_organization, :contact, :comments, :submitting_officer,
              :submitting_officer_contact, :url, :status, :source],
  uk:        [:country, :reference_number, :publish_date, :min_contract_value, :max_contract_value,
              :status, :url, :procurement_organization, :contact, :title, :description, :notice_type,
              :industry, :specific_location, :source],
  mca:       [:country, :publish_date, :url, :categories, :title, :description, :funding_source, :source],
}

json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    source = entry[:_source][:source].downcase
    json.id hit[:_id] if %(state uk).include?(source)
    json.call(entry[:_source], *field_lists[source.to_sym])
  end
end
