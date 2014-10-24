require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class DplData
    include ::Importer

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      action city country effective_date expiration_date fr_citation last_update
      name postal_code standard_order state street_address)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name beginning_date ending_date fr_citation)

    ENDPOINT = 'http://www.bis.doc.gov/dpl/dpl.txt'

    COLUMN_HASH = {
      name:            :name,
      effective_date:  :start_date,
      expiration_date: :end_date,
      standard_order:  :standard_order,
      action:          :remarks,
      fr_citation:     :federal_register_notice,
    }

    ADDRESS_HASH = {
      street_address: :address,
      city:           :city,
      state:          :state,
      country:        :country,
      postal_code:    :postal_code,
    }

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      rows = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: 'UTF-8', col_sep: "\t")

      ensure_expected_headers(rows.first)

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end

      model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

      doc[:id] = id
      doc[:source] = model_class.source
      doc[:source_list_url] =
        'http://www.bis.doc.gov/index.php/the-denied-persons-list'
      doc[:source_information_url] =
        'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/denied-persons-list'

      %i(start_date end_date).each do |field|
        doc[field] &&= parse_american_date(doc[field])
      end

      doc[:addresses] = rows.map do |row|
        remap_keys(ADDRESS_HASH, row.to_hash)
      end

      doc
    end
  end
end
