json.partial! 'shared/queryinfo'
json.results do
  json.array! @search[:hits] do |hit|
    entry = hit.deep_symbolize_keys
    json.id entry[:_id]
    json.call(entry[:_source], :label, :sub_class_of,
              :annotations, :datatype_properties, :object_properties,)
  end
end
