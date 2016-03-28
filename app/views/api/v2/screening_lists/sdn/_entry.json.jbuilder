type = entry[:_source][:type].casecmp('vessel').zero? ? 'vessel' : 'default'
json.partial! "api/v2/screening_lists/sdn/#{type}/entry", entry: entry
