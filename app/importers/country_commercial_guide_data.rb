require 'csv'
require 'open-uri'

class CountryCommercialGuideData
  include Importer

  COLUMN_HASH = {
    id:       :id,
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
    #CountryCommercialGuide.index entries.compact
  end

  private

  def process_source_hash(source_hash)
    entry = remap_keys COLUMN_HASH, source_hash
    entry[:report_type] = detect_report_type entry[:report_type]
    return nil if entry[:report_type] == "Market Research Report"
    entry[:url] = "http://mr.export.gov/docs/#{entry[:url]}" if entry[:url].present?
    entry[:content] = entry[:url] if entry[:url].present?
    entry
  end

  def detect_report_type(report_type_str)
    report_type = REPORT_TYPE_HASH[report_type_str]
    report_type ||= 'Market Research Report'
    report_type
  end
end
