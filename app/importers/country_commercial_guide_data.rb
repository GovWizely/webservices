require 'csv'
require 'open-uri'

class CountryCommercialGuideData
  include Importer

  ENDPOINT = "#{Rails.root}/data/country_commercial_guides/*"

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    entries = []
    Dir[@resource].each do |resource|
      source_file = open(resource)
      entries += build_entry_hashes(source_file)
      source_file.close
    end

    CountryCommercialGuide.index entries
  end

  private

  def build_entry_hashes(source_file)
    source_title = extract_source_title(source_file)
    pdf_url = extract_pdf_url(source_file)

    set_entry_fields(source_file, source_title, pdf_url)
  end

  def set_entry_fields(source_file, source_title, pdf_url)
    entries = []
    count = -1
    source_file.rewind
    source_file.each do |line|
      if line.include?('<h1 id="chap')
        count += 1
        entries[count] = {}
        section = line.split('">').last.strip
        section.slice!('</h1>')
        entries[count][:section] = section
        entries[count][:title] = source_title
        entries[count][:pdf_url] = pdf_url
        entries[count][:content] = line.gsub!("\n", '<br />')
      elsif !entries[count].nil?
        entries[count][:content] += line.gsub!("\n", '<br />')
      end
    end
    entries
  end

  def extract_source_title(source_file)
    source_title = ''
    source_file.each do |line|
      if line.include?('title')
        line.slice!('title: ')
        source_title = line.strip
        break
      end
    end
    source_title
  end

  def extract_pdf_url(source_file)
    source_file.rewind
    pdf_url = ''
    source_file.each do |line|
      if line.include?('pdf_url')
        line.slice!('pdf_url: ')
        pdf_url = line.strip
        break
      end
    end
    pdf_url
  end
end
