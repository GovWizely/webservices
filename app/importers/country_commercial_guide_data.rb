
require 'open-uri'

class CountryCommercialGuideData
  include Importer

  ENDPOINT = "#{Rails.root}/data/country_commercial_guides/yaml/*"

  def initialize(resource = ENDPOINT)
    @resource = resource
    @title, @chapter, @country, @pdf_url, @topics, @text_path, @md_file = ''
    @yaml_header = ''
    @entries = []
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    Dir[@resource].each do |resource|
      yaml_hash = YAML.load_file(resource)
      parse_yaml(yaml_hash)
      clear_output_directory
      build_entry_hashes
    end

    CountryCommercialGuide.index @entries
  end

  private

  def parse_yaml(hash)
    @md_file = hash['md_file']
    @title = hash['title']
    @country = hash['country']
    @pdf_url = hash['pdf_url']
    @text_path = hash['text_path']
    @entries = hash['entries'].map(&:symbolize_keys!)
  end

  def build_entry_hashes
    md_content = open("#{Rails.root}/data/country_commercial_guides/markdown/#{@md_file}")
    position = 0
    @entries.each_with_index do |entry, index|

      md_content.seek(position)
      md_content.each do |line|

        if line.include?('id="' + entry[:section_url] + '"')
          entry[:content] = line
        elsif !@entries[index + 1].nil? && line.include?('id="' + @entries[index + 1][:section_url] + '"')
          position = md_content.pos - line.length
          break
        elsif !entry[:content].nil?
          entry[:content] += line
        end

      end
      write_entry_to_file(entry)
      set_field_values(entry)
    end
  end

  def set_field_values(entry)
    entry[:title] = @title
    entry[:country] = lookup_country(@country)
    entry[:pdf_url] = @pdf_url
    entry[:section_url] = @text_path  + entry[:section_url] + '.html'
    entry[:content] = Nokogiri::HTML(entry[:content].gsub("\n", ' ')).text
  end

  def write_entry_to_file(entry)
    file_path = "#{Rails.root}/data/country_commercial_guides/#{@country.downcase}/#{Date.today}-#{entry[:section_url]}.md"
    File.open(file_path, 'w') do |f|
      f.write("--- \npermalink: '#{entry[:section_url]}.html' \npublished: true \n---\n")
      f.write(entry[:content])
    end
  end

  def clear_output_directory
    directory = "#{Rails.root}/data/country_commercial_guides/#{@country.downcase}/"
    FileUtils.rm_rf(Dir.glob("#{directory}/*"))
  end
end
