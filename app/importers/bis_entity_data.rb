require 'open-uri'
require 'csv'
require 'digest/md5'

class BisEntityData
  include Importer

  ENDPOINT = 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/915-consolidated-list-csv'

  COLUMN_HASH = {
    entity_number: :entity_number,
    sdn_type: :sdn_type,
    programs: :programs,
    name: :name,
    title: :title,
    federal_register_notice: :federal_register_notice,
    effective_date: :start_date,
    date_liftedwaived: :end_date,
    standard_order: :standard_order,
    license_requirement: :license_requirement,
    license_policy: :license_policy,
    weblink: :source_list_url,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"

    rows = CSV.parse(open(@resource, 'r:iso-8859-1:utf-8').read,
                      headers: true,
                      header_converters: :symbol)

    docs = group_rows(rows).map { |_, grouped| process_grouped_rows(grouped) }

    BisEntity.index docs
  end

  private

  def group_rows(rows)
    rows_by_name = {}
    rows.each do |row|
      next unless row[:name].present?
      key = generate_id(row)
      rows_by_name[key] ||= []
      rows_by_name[key] << row
    end
    rows_by_name
  end

  def process_grouped_rows(rows)
    doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

    doc[:id] = generate_id(rows.first);

    doc[:alt_names] = rows.map do |row|
      strip_nonascii(row[:alternate_name])
    end.compact.uniq

    doc[:addresses] = rows.map { |row| process_address(row) }.uniq

    doc[:start_date] &&= parse_american_date(doc[:start_date])
    doc[:source] = BisEntity.source

    doc
  end

  def strip_nonascii(str)
    str.present? ? str.delete("^\u{0000}-\u{007F}").squish : nil
  end

  ADDRESS_HASH = {
    address: :address,
    city: :city,
    country: :country,
    postal_code: :postal_code,
    stateprovince: :state,
  }

  def process_address(row)
    address = remap_keys(ADDRESS_HASH, row.to_hash)
    address[:country] &&= lookup_country(address[:country])
    address
  end

  def generate_id(row)
    Digest::SHA1.hexdigest(
      %i(name federal_register_notice effective_date).map { |f| row[f] }.join)
  end
end
