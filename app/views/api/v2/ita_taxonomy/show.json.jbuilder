entry = @search[:hits].first.deep_symbolize_keys
json.id entry[:_id]
json.call(entry[:_source], :label, :type, :sub_class_of,
          :annotations, :datatype_properties, :object_properties, :related_terms,)
