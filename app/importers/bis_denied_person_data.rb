require 'open-uri'
require 'csv'
require 'digest/md5'

class BisDeniedPersonData
  include Importer

  ENDPOINT = 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1007-dpl-txt'

  COLUMN_HASH = {
    name: :name,
    beginning_date: :start_date,
    ending_date: :end_date,
    standard_order: :standard_order,
    action: :remarks,
    fr_citation: :federal_register_notice,
  }

  ADDRESS_HASH = {
    street_address: :address,
    city: :city,
    state: :state,
    country: :country,
    postal_code: :postal_code,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    rows = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: "UTF-8", col_sep: "\t")

    docs = group_rows(rows).map { |_, grouped| process_grouped_rows(grouped) }

    BisDeniedPerson.index docs
  end

  private

  def group_rows(rows)
    rows_by_name = {}
    rows.each do |row|
      key = generate_id(row)
      rows_by_name[key] ||= []  # Init. to empty array if not yet present in hash.
      rows_by_name[key] << row
    end
    rows_by_name
  end

  def process_grouped_rows(rows)
    doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

    doc[:id] = generate_id(rows.first.to_hash)

    doc[:source] = BisDeniedPerson.source
    doc[:source_list_url] = @resource =~ URI::regexp ? @resource : nil

    %i(start_date end_date).each do |field|
      doc[field] &&= parse_american_date(doc[field])
    end

    doc[:addresses] = rows.map do |row|
      remap_keys(ADDRESS_HASH, row.to_hash)
    end

    doc
  end

  def generate_id(row)
    Digest::SHA1.hexdigest(
      %i(name beginning_date ending_date fr_citation).map { |f| row[f] }.join)
  end
end
