json.id entry[:_id]
json.call(entry[:_source], :source, :country, :specific_location, :title,
          :project_number, :industry, :project_size, :description, :tags,
          :publish_date, :end_date, :funding_source, :borrowing_entity,
          :procurement_organization, :contact, :comments, :submitting_officer,
          :submitting_officer_contact, :url, :status)
