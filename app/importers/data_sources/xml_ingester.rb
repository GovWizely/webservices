module DataSources
  class XMLIngester < Ingester
    include XMLUtils

    def ingest
      xml = Nokogiri::XML(@data)
      xml_records = xml.xpath(@metadata.yaml_dictionary[:_collection_path])
      records = xml_records.map { |node| process_node_info(node) }
      records.each { |row| insert_row(row) }
    end

    private

    def process_node_info(node)
      extract_fields(node, @metadata.xpaths_map)
    end
  end
end
