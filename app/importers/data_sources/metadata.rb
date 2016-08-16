module DataSources
  class Metadata
    include DataSources::Metadata::Selector
    attr_reader :yaml_dictionary

    def initialize(dictionary)
      @yaml_dictionary = YAML.load dictionary
    end

    def entries
      nested_entries, top_level_entries = partition_dictionary
      top_level_entries.merge(nested_entries)
    end

    def aggregation_terms
      return {} unless yaml_dictionary[:_aggregations].present?
      aggregations_clone_with_raw_field = yaml_dictionary[:_aggregations].deep_dup
      aggregations_clone_with_raw_field.values.each { |hash| hash[:field] << '.raw' }
      aggregations_clone_with_raw_field
    end

    def transform(row)
      row_hash = row.to_hash
      raw_hash = row_hash.merge(copied_fields_hash(row_hash)).slice(*entries.keys)
      xformed_hash = raw_hash.keys.map { |field_sym| [field_sym, transformers[field_sym].transform(raw_hash[field_sym])] }.to_h
      hash = xformed_hash.merge(constant_values).merge(transformed_collections(row))
      group_nested_entries(hash)
    end

    def transformed_collections(row)
      nested_collections.map do |nested_field_name, dict_yaml|
        nested_metadata = DataSources::Metadata.new(dict_yaml.to_yaml)
        mapped_row = row[nested_field_name].map { |entry| nested_metadata.transform(entry) }
        [nested_field_name, mapped_row]
      end.to_h
    end

    def copied_fields_hash(row_hash)
      copied_fields_mapping.reduce({}) do |result, (copy_to, copy_from)|
        result[copy_to] = row_hash[copy_from]
        result
      end
    end

    def transformers
      @transformers ||= entries.map { |field, meta| [field, DataSources::Transformer.new(meta)] }.to_h
    end

    def deep_stringified_yaml
      yaml_dictionary.deep_stringify_keys.to_yaml
    end

    def deep_symbolized_yaml
      yaml_dictionary.deep_symbolize_keys.to_yaml
    end

    private

    def partition_dictionary
      nested, top_level_entries = yaml_dictionary.reject { |key, _| key.to_s.start_with?('_') }
                                                 .partition { |_, v| v.key?(:_collection_path) }
                                                 .map(&:to_h)
      nested_entries = nested.map do |namespace, metadata|
        metadata.except(:_collection_path).each { |field, hash_entry| hash_entry[:search_path] = [namespace, field].join('.') }
      end
      nested_hash = nested_entries.reduce(:merge) || {}
      [nested_hash, top_level_entries]
    end

    def group_nested_entries(hash)
      nested_entries.each do |nested_entry|
        nested_hash = hash.extract!(*nested_entry[:fields].map(&:to_sym))
        hash[nested_entry[:name]] = nested_hash
      end
      hash
    end
  end
end
