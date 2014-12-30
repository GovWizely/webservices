
require 'open-uri'

class CountryCommercialGuideData
  include Importer

  ENDPOINT = "#{Rails.root}/data/country_commercial_guides/yaml/*"

  def initialize(resource = ENDPOINT)
    @resource = resource
    @title, @chapter, @country, @pdf_url, @md_file, @topics, @md_url = ''
    @entries = []
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    Dir[@resource].each do |resource|
      yaml_hash = YAML.load_file(resource)
      parse_yaml(yaml_hash)
      build_entry_hashes
    end

    CountryCommercialGuide.index @entries
  end

  private

  def parse_yaml(hash)
    @md_file = hash['md_file']
    @title = hash['title']
    @country = lookup_country(hash['country'])
    @pdf_url = hash['pdf_url']
    @md_url = hash['md_url']
    @entries = hash['entries']
    @entries.each(&:symbolize_keys!)
  end

  def build_entry_hashes
    md_content = open("#{Rails.root}/data/country_commercial_guides/markdown/#{@md_file}")
    position = 0
    @entries.each_with_index do |value, index|

      md_content.seek(position)
      md_content.each do |line|

        if line.include?('id="' + value[:section_url] + '"')
          value[:content] = ''
          value[:content] += line
        elsif !@entries[index + 1].nil? && line.include?('id="' + @entries[index + 1][:section_url] + '"')
          position = md_content.pos - line.length
          break
        elsif !value[:content].nil?
          value[:content] += line
        end

      end

      set_field_values(value)
    end
  end

  def set_field_values(hash)
    hash[:title] = @title
    hash[:country] = @country
    hash[:pdf_url] = @pdf_url
    hash[:md_url] = @md_url
    hash[:section_url] = @md_url + '#' + hash[:section_url]
  end
end
