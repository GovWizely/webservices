json.call(
  entry[:_source],
  :notice_type, :publish_date, :procurement_organization, :procurement_office,
  :procurement_organization_address, :classification_code, :industry,
  :procurement_office_address, :title, :contract_number, :end_date, :contact,
  :description, :competitive_procurement_strategy, :url, :specific_location,
  :specific_address
)
