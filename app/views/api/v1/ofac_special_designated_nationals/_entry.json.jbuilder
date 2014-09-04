type = entry[:_source][:sdn_type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v1/ofac_special_designated_nationals/#{type}/entry", entry: entry
