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

    rows = CSV.parse(open(@resource).read, headers: true,
                                           header_converters: :symbol,
                                           encoding: "ISO8859-1")

    docs = group_rows(rows).map { |_, grouped| process_grouped_rows(grouped) }

    BisEntity.index docs
  end

  private

  def group_rows(rows)
    rows_by_name = {}
    rows.each do |row|
      next unless row[:name].present?
      rows_by_name[row[:name]] ||= []
      rows_by_name[row[:name]] << row
    end
    rows_by_name
  end

  def process_grouped_rows(rows)
    doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

    doc[:id] = Digest::SHA1.hexdigest(doc[:name])

    doc[:license_requirement] = correct_encoding(doc[:license_requirement])
    doc[:license_policy] = correct_encoding(doc[:license_policy])

    doc[:alt_names] = rows.map do |row|
      correct_encoding(row[:alternate_name])
    end.compact.uniq

    doc[:addresses] = rows.map { |row| process_address(row) }.uniq

    doc[:start_date] &&= parse_american_date(doc[:start_date])
    doc[:source] = BisEntity.source

    doc
  end

  def correct_encoding(str)
    str.present? ? str.force_encoding('iso-8859-1').encode('utf-8').squish : nil
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
    address[:address] &&= correct_encoding(address[:address])
    address
  end
end
