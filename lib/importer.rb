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
    @html_entities_coder ||= HTMLEntities.new
    entry.each do |k, v|
      next unless v.is_a?(String)
      entry[k] = v.present? ? @html_entities_coder.decode(Sanitize.clean(v)).squish : nil
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
    when /\AU\.?S\.?(A\.?)?\Z/i then 'United States'
    else country_str
    end
  end


  # use the '|' symbol as a delimiter by default
  def normalize_industries( industries, delimiter="|" )
    if industries.is_a?( Array )
      normalize_industry_array( industries )
    elsif industries.is_a?( String )
      normalize_industry_array( industries.split( delimiter ) ).join( delimiter )
    # else
    #   industries # we want return result as-is if the input param is not of Array or String type. It will decrease coverage, though
    end
  end

  def normalize_industry_array( arr )
    arr.map{ |i| i.present? && ( IndustryMappingClient.map_industry( i ) || i ) }.uniq
  end

  def parse_date(date_str)
    Date.parse(date_str).to_s rescue nil
  end

  def parse_american_date(date_str)
    Date.strptime(date_str, '%m/%d/%Y').iso8601 rescue nil
  end

  def model_class
    self.class.name.sub(/Data$/, '').constantize
  end

  def import_then_purge_old
    fail 'Underlying model is unable to purge old documents' unless can_purge_old?
    start_time = Time.now
    import
    model_class.purge_old(start_time)
  end

  def can_purge_old?
    model_class.can_purge_old?
  end

  def lookup_state(state_str)
    State.normalize state_str
  end
end
