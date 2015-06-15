require 'open-uri'
require 'csv'
require 'digest/md5'

class EccnData
  include ::Importer

  EXPECTED_CSV_HEADERS = %w(description eccn1 eccn2 eccn3 eccn4 eccn5)

  ENDPOINT = "#{Rails.root}/data/eccns/eccn.descs.2015.05.20.csv"

  COLUMN_HASH = {
    eccn1: :eccn0,
    eccn2: :eccn1,
    eccn3: :eccn2,
    eccn4: :eccn3,
    eccn5: :eccn4,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    rows = CSV.parse(open(@resource, 'r:ISO-8859-1').read)

    if rows[0].map(&:downcase) != EXPECTED_CSV_HEADERS
      fail "'#{rows[0]}' are not the headers we expect"
    end

    model_class.index(rows[1..-1].map { |row| process_row(row) })
  end

  private

  def process_row(row)
    doc = {}
    doc[:description] = row[0]

    doc[:eccn0] = row[1]
    doc[:eccn1] = row[2]
    doc[:eccn2] = row[3]
    doc[:eccn3] = row[4]
    doc[:eccn4] = row[5]

    eccns = row[1..5].compact
    urls = eccns.map { |eccn| eccn_to_url(eccn) }.uniq

    doc[:url0] = urls[0]
    doc[:url1] = urls[1]
    doc[:url2] = urls[2]

    doc
  end

  def eccn_to_url(eccn)
    case eccn
    when /\A0/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/988-ccl0'
    when /\A1/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/989-ccl1'
    when /\A2/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/734-ccl2'
    when /\A3/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/990-ccl3'
    when /\A4/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1055-ccl4'
    when /\A5...2/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/951-ccl5-pt2'
    when /\A5/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/950-ccl5-pt1'
    when /\A6/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/952-ccl6'
    when /\A7/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1089-ccl7'
    when /\A8/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/863-category-8-marine'
    when /\A9/
      'http://www.bis.doc.gov/index.php/forms-documents/doc_download/991-ccl9'
    when /category\s+(\d)/i
      eccn_to_url "#{Regexp.last_match(1)}"
    else
      nil
    end
  end
end
