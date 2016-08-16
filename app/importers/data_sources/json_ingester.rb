module DataSources
  class JSONIngester < Ingester
    def ingest
      json = JSON.parse(@data)
      json_records = JsonPath.on(json, @metadata.yaml_dictionary[:_collection_path])
      records = json_records.map { |record| process_record_info(record) }
      insert(records)
    end

    private

    def process_record_info(record)
      hash = extract_fields(record, @metadata.mapped_paths_map)
      @metadata.nested_collections.each_pair do |k, dict_yaml|
        m = DataSources::Metadata.new(dict_yaml.to_yaml)
        coll = record[dict_yaml[:_collection_path]]
        hash[k] = coll.map { |e| extract_fields(e, m.mapped_paths_map) }
      end
      hash
    end

    def extract_fields(parent_record, path_hash)
      path_hash.map { |key, path| [key, JsonPath.on(parent_record, path).first] }.to_h
    end
  end
end
