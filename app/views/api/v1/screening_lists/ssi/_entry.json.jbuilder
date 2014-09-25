type = entry[:_source][:type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v1/screening_lists/ssi/#{type}/entry", entry: entry
