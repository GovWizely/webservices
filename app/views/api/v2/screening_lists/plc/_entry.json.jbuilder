type = entry[:_source][:type].casecmp('vessel').zero? ? 'vessel' : 'default'
json.partial! "api/v2/screening_lists/plc/#{type}/entry", entry: entry
