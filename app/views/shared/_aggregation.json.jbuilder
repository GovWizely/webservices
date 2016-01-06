json.aggregations do
  @search[:aggregations].each do |k, v|
    json.set! k, v[:buckets]
  end
end unless @search[:aggregations].blank?
