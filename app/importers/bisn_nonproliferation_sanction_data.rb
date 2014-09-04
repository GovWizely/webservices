require 'open-uri'
require 'csv'
require 'digest/md5'

class BisnNonproliferationSanctionData
  include Importer

  ENDPOINT = "#{Rails.root}/data/bisn_nonproliferation_sanctions/isn.csv"

  COLUMN_HASH = {
    name: :name,
    federal_register_notice: :federal_register_notice,
    effective_date: :start_date,
    date_liftedwaivedexpired: :end_date
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    rows = CSV.parse(open(@resource, "r:ISO-8859-1").read, headers: true, header_converters: :symbol, encoding: "UTF-8")

    docs = group_rows(rows).map { |_, grouped| process_grouped_rows(grouped) }

    BisnNonproliferationSanction.index docs
  end

  private

  def group_rows(rows)
    rows_by_name = {}
    rows.each do |row|
      next if entity_expired?(row)
      key = generate_id(row)
      rows_by_name[key] ||= []
      rows_by_name[key] << row
    end
    rows_by_name
  end

  def process_grouped_rows(rows)
    doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

    doc[:id] = generate_id(rows.first.to_hash)
    doc[:source] = BisnNonproliferationSanction.source
    doc[:source_list_url] = 'http://www.state.gov/t/isn/c15231.htm'

    %i(start_date end_date).each do |field|
      doc[field] &&= parse_american_date(doc[field])
    end

    doc[:programs] = rows.map { |row| row[:programs] }

    doc
  end

  def entity_expired?(row)
    parse_american_date(row[:date_liftedwaivedexpired]) < Time.now rescue nil
  end

  def generate_id(row)
    Digest::SHA1.hexdigest(
      %i(name effective_date federal_register_notice).map { |f| row[f] }.join)
  end
end
