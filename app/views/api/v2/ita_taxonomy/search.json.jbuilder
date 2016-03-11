json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :label, :subject, :sub_class_of,
              :annotations, :datatype_properties, :object_properties, :query_expansion_terms)
  end
end
