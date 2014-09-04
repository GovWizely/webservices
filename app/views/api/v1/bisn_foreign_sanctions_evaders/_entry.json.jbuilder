type = entry[:_source][:sdn_type].downcase == 'vessel' ? 'vessel' : 'default'
json.partial! "api/v1/bisn_foreign_sanctions_evaders/#{type}/entry", entry: entry
