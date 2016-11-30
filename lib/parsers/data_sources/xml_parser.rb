class DataSources::XMLParser
  include DataTypeGuesser

  def initialize(xml_string)
    @xml_string = xml_string
  end

  def generate_dictionary
    xml = Nokogiri::XML(@xml_string)
    with_collection_path(xml) do |collection_path|
      generate_dictionary_from_xml(xml, collection_path)
    end
  end

  private

  def generate_dictionary_from_xml(xml, collection_path)
    dictionary = { '_collection_path' => collection_path }
    xml.xpath(collection_path).first.elements.collect(&:name).uniq.each do |field_name|
      guessed_column_type = guess_column_type_from_xml_data(xml, collection_path, field_name)
      dictionary[sanitize_header(field_name)] = default_dictionary_metadata_hash(field_name, guessed_column_type) if guessed_column_type.present?
    end
    dictionary
  end

  def with_collection_path(xml)
    root_node_name = xml.children.first.name
    collection_name = xml.xpath("#{root_node_name}/*").first.name
    yield "/#{root_node_name}/#{collection_name}"
  end

  def guess_column_type_from_xml_data(xml, collection_path, field_name)
    source_xpath = "/#{collection_path}/#{field_name}"
    field_values = xml.xpath(source_xpath).children.map(&:inner_text).join("\n")
    converted_field_values = CSV.parse(field_values, converters: [:date, :numeric], headers: false).flatten
    guess_column_type_from_data(converted_field_values)
  rescue CSV::MalformedCSVError
    'string'
  end
end
