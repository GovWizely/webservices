field_lists = {
  australia: [:agency, :contract_value, :description, :parent_id, :procurement_method, :publish_date_amended, :status, :topic, :url],
  canada:    [:country, :title, :reference_number, :contract_number, :publish_date, :end_date,
              :publish_date_amended, :status, :industry,
              :specific_location, :notice_type, :trade_agreement, :bid_type,
              :competitive_procurement_strategy, :non_competitive_procurement_strategy,
              :procurement_organization, :implementing_entity, :description, :contact, :urls],
  fbo:       [:notice_type, :publish_date, :procurement_organization, :procurement_office,
              :procurement_organization_address, :classification_code, :industry,
              :procurement_office_address, :title, :contract_number, :end_date, :contact,
              :description, :competitive_procurement_strategy, :url, :specific_location,
              :specific_address],
  state:     [:country, :specific_location, :title,
              :project_number, :industry, :project_size, :description, :tags,
              :publish_date, :end_date, :funding_source, :borrowing_entity,
              :procurement_organization, :contact, :comments, :submitting_officer,
              :submitting_officer_contact, :url, :status],
  uk:        [:country, :reference_number, :publish_date, :min_contract_value, :max_contract_value,
              :status, :url, :procurement_organization, :contact, :title, :description, :notice_type,
              :industry, :specific_location],
}

json.call(@search, :total, :offset)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id hit['_id']                        if entry[:_source][:source].downcase == 'state' || entry[:_source][:source].downcase == 'uk'

    if !params[:sources] || params[:sources].empty?
      if entry[:_source][:source] == 'UK' || entry[:_source][:source] == 'STATE'
        json.type (entry[:_source][:source].downcase + '_trade_lead')
      elsif entry[:_source][:source] == 'FBO'
        json.type 'fbopen_lead'
      else
        json.type (entry[:_source][:source].downcase + '_lead')
      end
    end

    json.source entry[:_source][:lead_source] if entry[:_source][:source].downcase == 'state'
    json.call(entry[:_source], *field_lists[entry[:_source][:source].downcase.to_sym])
  end
end
