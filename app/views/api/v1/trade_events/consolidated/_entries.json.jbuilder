source_fields = {
  exim: [
    :event_name,
    :start_date,
    :end_date,
    :registration_link,
    :description,
    :url,
    :city,
    :state,
    :country,
    :industries,
    :source
  ],

  ita: [
  	:event_name,
    :event_type,
    :start_date,
    :end_date,
    :cost,
    :registration_link,
    :registration_title,
    :description,
    :industries,
    :url,
    :venue,
    :city,
    :state,
    :country,
    :contacts,
    :source
	],
	sba: [
		:event_name,
    :event_type,
    :start_date,
    :start_time,
    :end_date,
    :end_time,
    :time_zone,
    :cost,
    :registration_link,
    :description,
    :industries,
    :venue,
    :address,
    :city,
    :state,
    :country,
    :contacts,
    :source
	],

	ustda: [
		:event_name, :event_type, :start_date, :end_date, :cost,
    :cost_currency, :registration_link, :registration_title,
    :description, :industries, :url, :venues, :contacts,
    :source
	]
}

json.array! entries do |hit|
  entry = hit.deep_symbolize_keys
  src_name = ( local_assigns[:source] ? source : entry[:_source][:source].downcase.to_sym )
  json.id(entry[:_id]) if src_name != :sba
  json.call(entry[:_source], *source_fields[ src_name ] )
end