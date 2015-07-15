module Importer
  # The module provides functionality useful for importing source data, and
  # can be included into any class that will do so.

  def self.included(base)
    base.class_eval do
      base.send(:prepend, ParentInstanceMethods)
    end
  end

  def available_version
    nil
  end

  def stored_version
    model_class.stored_metadata[:version]
  end

  module ParentInstanceMethods
    def import
      Rails.logger.info "#{self.class.name}: import starting."

      if resource_changed?
        start_time = Time.now if can_purge_old?
        super
        update_metadata available_version
        model_class.purge_old(start_time) if can_purge_old?
        Rails.logger.info "#{self.class.name}: import finished (resource updated, new data indexed)."
      else
        Rails.logger.info "#{self.class.name}: import finished (resource unchanged, no new data indexed)."
      end
    end
  end

  def resource_changed?
    return true unless available_version
    stored_version != available_version
  end

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
    IsoCountryCodes.search_by_name(normalized_country_str).first.alpha2 if normalized_country_str
  rescue IsoCountryCodes::UnknownCodeError
    Rails.logger.error "Could not find a country code for #{country_str}"
    nil
  end

  def country_name_mappings
    @@country_name_mappings ||= YAML.load_file(File.join(__dir__, 'country_mappings.yaml'))
  end

  def normalize_country(country_str)
    country_str = country_str.strip

    mapping = country_name_mappings.find do |_, regexes|
      regexes.any? { |r| r.match country_str }
    end

    if mapping
      name = mapping.first
      # avoid error logs on names we don't have a coutry to map it to
      name == '<undetermined>' ? nil : name
    else
      country_str
    end
  end

  def normalize_industry(industry)
    source = model_class.to_s
    Rails.cache.fetch("#{source}/#{industry}", expires_in: 90.seconds) do
      IndustryMappingClient.map_industry(industry, source)
    end
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

  def lookup_state(state_str)
    State.normalize state_str
  end

  def parse_city_from_address(event_hash)
    event_hash[:address].grep(/[A-Z]{2} [0-9]{5}(-\d{4})*$/) do |address_line|
      address_line.split(',').reverse[1].to_s.squish
    end.compact.first
  end

  delegate :can_purge_old?, to: :model_class
  delegate :stored_metadata, :update_metadata, to: :model_class
end
