module XMLUtils
  def extract_fields(parent_node, path_hash)
    Hash[path_hash.map { |key, path| [key, extract_node(parent_node.xpath(path).first)] }]
  end

  def extract_node(node)
    node_content = node ? node.inner_text.squish : nil
    node_content.present? ? node_content : nil
  end
end
