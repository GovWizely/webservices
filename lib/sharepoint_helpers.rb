module SharepointHelpers
  def extract_urls(parent_node, hash)
    hash[:file_url] = []
    hash[:image_url] = []
    parent_node.xpath('//images/image').each do |node|
      hash[:image_url] << node.attribute('src').text
    end
    parent_node.xpath('//files/file').each do |node|
      hash[:file_url] << node.attribute('src').text
    end
    hash
  end

  def extract_source_agencies(parent_node, hash)
    hash[:source_agencies] = []
    hash[:source_business_units] = []
    hash[:source_offices] = []

    parent_node.xpath('//source_agencies/source_agency').each do |source_agency|
      hash[:source_offices] += extract_nodes(source_agency.xpath('//source_office'))

      source_agency.xpath('source_business_unit').each do |source_business_unit|
        hash[:source_business_units] << source_business_unit.children.first.text
      end
      hash[:source_agencies] << source_agency.children.first.text
    end
    hash
  end

  def extract_topics(parent_node, hash)
    hash[:topics] = []
    hash[:sub_topics] = []
    hash = extract_sub_elements(parent_node, hash, :topics, :sub_topics, '//topic', '//sub_topic')
    #parent_node.xpath('//tags//topics//topic').each do |topic|
    #  hash[:sub_topics] += extract_nodes(topic.xpath('//sub_topic'))
    #  hash[:topics] << topic.children.first.text
    #end
    hash
  end

  def extract_geo_regions(parent_node, hash)
    hash[:geo_regions] = []
    hash[:geo_subregions] = []
    hash = extract_sub_elements(parent_node, hash, :geo_regions, :geo_subregions, '//geo_region', '//geo_subregion')
    #parent_node.xpath('//tags//geo_regions//geo_region').each do |geo_region|
    #  hash[:geo_subregions] += extract_nodes(geo_region.xpath('//geo_subregion'))
    #  hash[:geo_regions] << geo_region.children.first.text
    #end
    hash
  end

  def extract_sub_elements(parent_node, hash, parent_key, child_key, parent_path, child_path)
    parent_node.xpath(parent_path).each do |node|
      hash[child_key] += extract_nodes(node.xpath(child_path))
      hash[parent_key] << node.children.first.text
    end
    hash
  end

  def remove_duplicates(hash)
    hash.each do |_k, v|
      if v.class == Array
        v.uniq!
      end
    end
    hash
  end

  def replace_nulls(hash)
    hash.each do |k, v|
      if v.nil? && is_date?(k) == false
        hash[k] = ''
      end
    end
  end

  def is_date?(key)
    date_keys = [:creation_date, :release_date, :expiration_date]
    date_keys.include?(key)
  end

  def generate_sp_query(terms, q_terms, json)
    json.bool do
      json.must do |_must_json|
        json.child! { generate_multi_match(json, q_terms + terms, @q) } if @q
        terms.each do |term|
          json.child! { json.match { json.set! term, instance_variable_get("@#{term}") } } if instance_variable_get("@#{term}")
        end
      end
    end
  end

  def generate_sp_filter(json)
    json.bool do
      json.must do
        generate_date_range(json, 'creation_date')
        generate_date_range(json, 'release_date')
        generate_date_range(json, 'expiration_date')
        json.child! { json.terms { json.countries @countries } } if @countries
      end
    end
  end

  def generate_date_range(json, date_str)
    date_start = instance_variable_get("@#{date_str}_start")
    date_end = instance_variable_get("@#{date_str}_end")
    if date_start || date_end
      json.child! do
        json.range do
          json.set! date_str.to_sym do
            json.from date_start if date_start
            json.to date_end if date_end
          end
        end
      end
    end
  end
end
