json.call(@search, :total, :offset, :max_score)
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.partial! "api/v2/screening_lists/#{entry[:_source][:source][:code].downcase}/entry", entry: entry
    json.score entry[:_score]
  end
end
