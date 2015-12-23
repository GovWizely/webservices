module XMLUtils
  def extract_fields(parent_node, path_hash)
    Hash[path_hash.map { |key, path| [key, extract_node(parent_node.xpath(path).first)] }]
  end

  def extract_multi_valued_fields(parent_node, xpath_hash)
    Hash[xpath_hash.map { |key, xpath| [key, extract_nodes(parent_node.xpath(xpath))] }]
  end

  def extract_nodes(nodes)
    nodes.map { |node| extract_node(node) }.compact
  end

  def extract_node(node)
    node_content = node ? node.inner_text.squish : nil
    node_content.present? ? node_content : nil
  end
end
