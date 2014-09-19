require 'open-uri'
require 'csv'
require 'digest/md5'

class BisUnverifiedPartyData
  include Importer

  ENDPOINT = "http://www.bis.doc.gov/index.php/forms-documents/doc_download/1053-unverified-list"

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    rows = CSV.parse(open(@resource).read, encoding: "UTF-8")

    docs = grouped_rows(rows).map { |row_name, rows| process_grouped_rows(row_name, rows) }

    BisUnverifiedParty.index docs
  end

  private

  def grouped_rows(rows)
    grouped = {}

    # We're going to throw each row into a bucket. The buckets are labelled
    # by entity name (row[1]). We need to be able to know which bucket to throw
    # a given row into based on its name or its address. bucket_for maps a
    # name or address to an existing bucket if a suitable one exists, otherwise
    # a new key will be created in bucket_for after processing the row.
    bucket_for = {}

    rows.each do |row|
      address = row[2]
      names = row[1].split(', a.k.a. ')

      name_with_existing_bucket = names.find { |n| bucket_for[n] }
      bucket = bucket_for[name_with_existing_bucket] if name_with_existing_bucket
      bucket ||= bucket_for[address] || names.first

      grouped[bucket] = [] unless grouped[bucket]

      grouped[bucket] << row
      bucket_for[address] = bucket
      names.each { |n| bucket_for[n] = bucket }
    end

    grouped
  end

  def process_grouped_rows(row_name, rows)
    doc = {}
    doc[:name] = row_name
    doc[:id] = Digest::SHA1.hexdigest(row_name)
    doc[:source] = BisUnverifiedParty.source

    doc[:addresses] = rows.map do |row|
     { address: row[2],
       city: nil,
       state: nil,
       postal_code: nil,
       country: lookup_country(row[0]) }
    end.uniq

    doc[:alt_names] =
      rows.map { |row| row[1].split(', a.k.a. ') }
      .flatten
      .uniq
      .delete_if { |name| name == row_name }

    doc
  end
end
