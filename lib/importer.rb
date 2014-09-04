module Importer
  def extract_fields(parent_node, path_hash)
    Hash[path_hash.map { |key, path| [key, extract_node(parent_node.xpath(path).first)] }]
  end

  def extract_multi_valued_fields(parent_node, xpath_hash)
    Hash[xpath_hash.map { |key, xpath| [key, extract_nodes(parent_node.xpath(xpath))] }]
  end

  def remap_keys(mapping, article_hash)
    Hash[article_hash.slice(*mapping.keys).map { |k, v| [mapping[k], v] }]
  end

  def sanitize_entry(entry)
    entry.each do |k, v|
      next if v.is_a?(Array)
      entry[k] = v.present? ? v.squish : nil
    end
    entry
  end

  def extract_nodes(nodes)
    nodes.map { |node| extract_node(node) }.compact
  end

  def extract_node(node)
    node_content = node ? node.inner_text.squish : nil
    node_content.present? ? node_content : nil
  end

  def lookup_country(country_str)
    normalized_country_str = normalize_country(country_str)
    IsoCountryCodes.search_by_name(normalized_country_str).first.alpha2
  rescue IsoCountryCodes::UnknownCodeError => e
    Rails.logger.error "Could not find a country code for #{country_str}"
    nil
  end

  def normalize_country(country_str)
    case country_str
    when /\ABurma \(Myanmar\)\Z/i then 'Myanmar'
    when /Congo, Democratic Rep\. of the/i then 'Congo, the Democratic Republic of the'
    when /\ADemocratic Republic of (?:the )?Congo\Z/i then 'Congo, the Democratic Republic of the'
    when /Congo, Republic of the/i then 'Congo'
    when /Republic of the Congo/i then 'Congo'
    when /\ACote d'Ivoire\Z/i then "Côte d'Ivoire"
    when /\A(South Korea|Korea \(South\))\Z/i then 'Korea, Republic of'
    when /\AVietnam\Z/i then 'Viet Nam'
    when /\AKyrgyz Republic\Z/i then 'Kyrgyzstan'
    when /\AKosovo\Z/i then 'Serbia'
    when /\ALaos\Z/i then "Lao People's Democratic Republic"
    when /\ASt\. Lucia\Z/i then 'Saint Lucia'
    when /\ASão Tomé & Príncipe\Z/i then 'Sao Tome and Principe'
    else country_str
    end
  end

  def parse_date(date_str)
    Date.parse(date_str).to_s rescue nil
  end

  def parse_american_date(date_str)
    Date.strptime(date_str, '%m/%d/%Y').iso8601 rescue nil
  end
end
