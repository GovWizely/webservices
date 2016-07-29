module DataSources::Metadata::Selector
  def singular_entries
    entries.reject { |key, _| grouped_fields.include?(key) }
  end

  def top_level_singular_entries
    singular_entries.reject { |key, meta| grouped_fields.include?(key) || meta.key?(:search_path) }
  end

  def grouped_fields
    nested_entries.collect { |e| e[:fields] }.flatten.map(&:to_sym)
  end

  def groups
    nested_entries.collect { |e| e[:name] }
  end

  def nested_entries
    yaml_dictionary[:_nested_entries] || []
  end

  def filter_fields
    fields_matching_hash type: 'enum'
  end

  def plural_filter_fields
    fields_matching_hash type: 'enum', indexed: true, plural: true
  end

  def pluralized_filter_fields
    plural_filter_fields.map { |singular_key, value| [singular_key.to_s.pluralize.to_sym, value] }.to_h
  end

  def singular_filter_fields
    fields_matching_hash type: 'enum', indexed: true, plural: false
  end

  def fulltext_fields
    fields_matching_hash type: 'string', indexed: true
  end

  def date_fields
    fields_matching_hash type: 'date', indexed: true
  end

  def unique_fields
    fields_matching_hash use_for_id: true
  end

  def nested_collections
    yaml_dictionary.reject { |key, _| key.to_s.start_with?('_') }
                   .select { |_, value_hash| value_hash.key?(:_collection_path) }
  end

  def non_fulltext_fields
    pluralized_filter_fields.merge(singular_filter_fields).merge(date_fields)
  end

  def semantic_query_service_configuration
    yaml_dictionary[:_semantic_query_service]
  end

  def copied_fields_mapping
    pluck_field_from_values(entries.find_all { |_, meta| meta.key?(:copy_from) }, :copy_from).map { |k, v| [k, v.to_sym] }.to_h
  end

  def mapped_paths_map
    paths_map.except(*(copied_fields_mapping.keys + constant_values.keys))
  end

  def paths_map
    pluck_field_from_values(entries.reject { |_, meta| meta.key?(:_collection_path) }, :source)
  end

  def constant_values
    pluck_field_from_values(entries.find_all { |_, meta| meta.key?(:constant) }, :constant)
  end

  private

  def pluck_field_from_values(hash, key)
    hash.map { |field, meta| [field, meta[key]] }.to_h
  end

  def fields_matching_hash(hash)
    singular_entries.find_all { |_, meta| meta.include_hash?(hash) }.to_h
  end
end
