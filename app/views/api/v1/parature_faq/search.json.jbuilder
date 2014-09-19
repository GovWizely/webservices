json.(@search, :total)
json.results do
  json.array! @search[:hits] do |hit|
    parature_faq = hit.deep_symbolize_keys
    json.id parature_faq[:_id]
    json.(parature_faq[:_source],
    	:question, :answer, :published, :create_date, :update_date, :user_rating, :topic, :industry, :country
      )
  end
end