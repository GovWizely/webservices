module DataSources
  class Metadata
    attr_reader :yaml_dictionary

    def initialize(dictionary)
      @yaml_dictionary = YAML.load dictionary
    end

    def entries
      yaml_dictionary.reject { |key, _| key.to_s.start_with?('_') }
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

    def paths_map
      entries.map { |field, meta| [field, meta[:source]] }.to_h
    end

    def non_fulltext_fields
      pluralized_filter_fields.merge(singular_filter_fields).merge(date_fields)
    end

    def transform(row)
      hash = row.to_hash.slice(*entries.keys)
      hash.keys.map { |field_sym| [field_sym, transformers[field_sym].transform(hash[field_sym])] }.to_h
    end

    def transformers
      entries.map { |field, meta| [field, DataSources::Transformer.new(meta)] }.to_h
    end

    def deep_stringified_yaml
      yaml_dictionary.deep_stringify_keys.to_yaml
    end

    def deep_symbolized_yaml
      yaml_dictionary.deep_symbolize_keys.to_yaml
    end

    private

    def fields_matching_hash(hash)
      entries.find_all { |_, meta| meta.include_hash?(hash) }.map { |field, meta| [field, meta[:description]] }.to_h
    end
  end
end
