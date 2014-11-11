type = entry[:_source][:type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v2/screening_lists/plc/#{type}/entry", entry: entry
