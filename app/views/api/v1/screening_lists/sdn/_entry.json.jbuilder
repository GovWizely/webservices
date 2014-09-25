type = entry[:_source][:type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v1/screening_lists/sdn/#{type}/entry", entry: entry
