type = entry[:_source][:nsp_type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v1/screening_lists/plc/#{type}/entry", entry: entry
