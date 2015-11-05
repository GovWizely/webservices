json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v2/screening_lists/#{entry[:_source][:source][:code].downcase}/entry", entry: entry

    if @_request['fuzzy_name'].present?
      json.score entry[:_score]
      json.matched_fields entry[:highlight]
    end
  end
end
