class DataSources::JSONParser
  include DataTypeGuesser

  def initialize(json_string)
    @json_string = json_string
  end

  def generate_dictionary
    json = JSON.parse(@json_string)
    collection_path = guess_collection_path(json)
    generate_dictionary_from_json(json, collection_path)
  end

  private

  def generate_dictionary_from_json(json, collection_path)
    dictionary = { '_collection_path' => collection_path }
    JsonPath.on(json, collection_path).first.keys.each do |field_name|
      column_values = JsonPath.on(json, join_path(collection_path, field_name))
      guessed_column_type = guess_column_type_from_data(column_values)
      dictionary[sanitize_header(field_name)] = default_dictionary_metadata_hash(field_name, guessed_column_type) if guessed_column_type.present?
    end
    dictionary
  end

  def guess_collection_path(json)
    path = nil
    queue = [[path, json]]
    while queue.any? && path.nil?
      candidate_path, json_remainder = queue.shift
      json_remainder.each do |key, value|
        if value.is_a?(Array)
          path = "$#{join_path(candidate_path, key)}[*]"
          break
        elsif value.is_a?(Hash)
          queue << [join_path(candidate_path, key), value]
        end
      end
    end
    path || '$[*]'
  end

  def join_path(path, field_name)
    [path, field_name].join('.')
  end
end
