require 'csv'
require 'open-uri'

class MarketResearchData
  include Importer

  COLUMN_HASH = {
    id:       :id,
    country:  :countries,
    descrip:  :description,
    expdate:  :expiration_date,
    industry: :industries,
    origform: :report_type,
    ttitle:   :title,
    doc:      :url,
  }

  REPORT_TYPE_HASH = {
    'bmr11' => 'Best Market Research',
    'ccg1'  => 'Country Commercial Guide',
  }

  def initialize(resource = 'http://mr.export.gov/nextgen/ng.txt')
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    entries = []
    MrlParser.foreach(@resource) do |source_hash|
      entries << process_source_hash(source_hash)
    end
    MarketResearch.index entries
  end

  private

  def process_source_hash(source_hash)
    entry = remap_keys COLUMN_HASH, source_hash
    entry[:countries] = entry[:countries].present? ? extract_countries(entry[:countries]) : nil
    entry[:expiration_date] = parse_date entry[:expiration_date]
    entry[:industries] = entry[:industries].present? ? str_to_a(entry[:industries]) : nil
    entry[:report_type] = detect_report_type entry[:report_type]
    entry[:url] = "http://mr.export.gov/docs/#{entry[:url]}" if entry[:url].present?
    entry
  end

  def extract_countries(countries_str)
    countries = str_to_a(countries_str)
    countries.map { |country| lookup_country(country) }.compact.sort
  end

  def str_to_a(input_str, delimiter = '|')
    input_str.split(delimiter).map do |item|
      item.present? ? item.squish : nil
    end.compact
  end

  def detect_report_type(report_type_str)
    report_type = REPORT_TYPE_HASH[report_type_str]
    report_type ||= 'Market Research Report'
    report_type
  end
end
