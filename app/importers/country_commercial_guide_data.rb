require 'csv'
require 'open-uri'

class CountryCommercialGuideData
  include Importer

  ENDPOINT = "#{Rails.root}/data/country_commercial_guides/*"

  COLUMN_HASH = {
    id:       :id,
    origform: :report_type,
    ttitle:   :title,
    doc:      :url,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    entries = Dir[@resource].map do |resource|
      source_file = open(resource)
      build_entry_hash(source_file)
    end.compact

    CountryCommercialGuide.index entries
  end

  private

  def build_entry_hash(source_file)
    entry = {}
    entry = extract_title(source_file, entry)
    entry[:content] = source_file.read
    entry[:url] = File.basename(source_file.path)
    entry
  end

  def extract_title(source_file, entry)
    source_file.each do |line|
      if line.include?("title")
        line.slice!("title: ")
        entry[:title] = line.strip
        break
      end
    end
    entry
  end

end
