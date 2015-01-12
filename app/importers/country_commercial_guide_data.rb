
class CountryCommercialGuideData
  include Importer

  ENDPOINT = "#{Rails.root}/data/country_commercial_guides/yaml/*"

  def initialize(resource = ENDPOINT)
    @resource = resource
    @title, @country, @pdf_url, @text_path, @md_file, @chapter = ''
    @entries = []
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    entries = []
    Dir[@resource].each do |resource|
      yaml_hash = YAML.load_file(resource)
      parse_yaml(yaml_hash)
      clear_output_directory
      build_entry_hashes
      entries += @entries
    end

    CountryCommercialGuide.index entries
  end

  private

  def parse_yaml(hash)
    @md_file = hash['md_file']
    @pdf_title = hash['pdf_title']
    @country = hash['country']
    @pdf_url = hash['pdf_url']
    @section_url_prefix = hash['section_url_prefix']
    @entries = hash['entries'].map(&:symbolize_keys!)
  end

  def build_entry_hashes
    md_content = open("#{Rails.root}/data/country_commercial_guides/markdown/#{@md_file}")
    position = 0
    @entries.each do |entry|

      md_content.seek(position)
      md_content.each do |line|

        if line.include?('id="' + entry[:section_id])
          entry[:content] = ''
        elsif !entry[:content].nil? && line.include?('</div>')
          position = md_content.pos
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
    entry[:pdf_title] = @pdf_title
    entry[:pdf_url] = @pdf_url
    entry[:pdf_section] = entry.delete(:section)
    entry[:pdf_chapter] = entry.delete(:chapter)

    entry[:section_title] = entry[:pdf_chapter].dup
    entry[:section_title].slice!(/Chapter [0-9]*: /)
    entry[:country] = lookup_country(@country)
    entry[:section_url] = @section_url_prefix  + entry.delete(:section_id) + '.html'
    entry[:topic] = entry[:pdf_section]
    entry[:industry] = '' unless entry.key?(:industry)

    entry[:content] = Nokogiri::HTML(entry[:content].gsub("\n", ' ')).text
    entry[:content].gsub!("\r", ' ')
    entry[:content].gsub!("\t", ' ')
  end

  def write_entry_to_file(entry)
    file_path = "#{Rails.root}/data/country_commercial_guides/#{@country.downcase}/#{Date.today}-#{entry[:section_id]}.md"
    File.open(file_path, 'w') do |f|
      f.write("--- \npermalink: '#{@country.downcase}/#{entry[:section_id]}.html' \npublished: true \nlayout: default\n---\n")
      f.write(entry[:content])
    end
  end

  def clear_output_directory
    directory = "#{Rails.root}/data/country_commercial_guides/#{@country.downcase}/"
    FileUtils.rm_rf(Dir.glob("#{directory}/*"))
  end
end
