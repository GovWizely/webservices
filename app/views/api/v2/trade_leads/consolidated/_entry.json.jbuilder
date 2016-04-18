source_field_lists = {
  australia: [:agency, :contract_value, :description, :parent_id, :procurement_method, :publish_date_amended,
              :status, :industry, :ita_industries, :project_number, :publish_date, :start_date, :end_date,
              :country, :country_name, :url, :source, :trade_regions, :world_regions,],
  canada:    [:country, :country_name, :title, :reference_number, :contract_number, :publish_date, :end_date,
              :publish_date_amended, :status, :industry, :ita_industries,
              :specific_location, :notice_type, :trade_agreement, :bid_type,
              :competitive_procurement_strategy, :non_competitive_procurement_strategy,
              :procurement_organization, :implementing_entity, :description, :contact, :urls, :source,
              :trade_regions, :world_regions,],
  fbo:       [:notice_type, :publish_date, :procurement_organization, :procurement_office,
              :procurement_organization_address, :classification_code, :industry, :ita_industries,
              :procurement_office_address, :title, :contract_number, :end_date, :contact,
              :description, :competitive_procurement_strategy, :url, :country, :country_name,
              :specific_address, :source, :trade_regions, :world_regions,],
  state:     [:lead_source, :country, :country_name, :specific_location, :title,
              :project_number, :industry, :ita_industries, :project_size, :description, :tags,
              :publish_date, :end_date, :funding_source, :borrowing_entity,
              :procurement_organization, :contact, :comments, :submitting_officer,
              :submitting_officer_contact, :url, :status, :source, :trade_regions, :world_regions,],
  uk:        [:country, :country_name, :reference_number, :publish_date, :min_contract_value, :max_contract_value,
              :status, :url, :procurement_organization, :contact, :title, :description, :notice_type,
              :industry, :ita_industries, :specific_location, :source, :trade_regions, :world_regions,],
  mca:       [:country, :country_name, :publish_date, :url, :categories, :title, :description, :funding_source, :source,
              :trade_regions, :world_regions,],
  ustda:     [:title, :publish_date, :end_date, :description, :url, :source, :country, :country_name,
              :trade_regions, :world_regions,],
}

source = entry[:_source][:source].downcase.to_sym
json.id entry[:_id]
json.call(entry[:_source], *source_field_lists[source])
