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
      extract_fields(record, @metadata.uncopied_paths_map)
    end

    def extract_fields(parent_record, path_hash)
      path_hash.map { |key, path| [key, JsonPath.on(parent_record, path).first] }.to_h
    end
  end
end
