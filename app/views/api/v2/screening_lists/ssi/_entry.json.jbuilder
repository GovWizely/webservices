type = entry[:_source][:type].casecmp('vessel').zero? ? 'vessel' : 'default'
json.partial! "api/v2/screening_lists/ssi/#{type}/entry", entry: entry
