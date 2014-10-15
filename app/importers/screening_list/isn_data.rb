require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class IsnData
    include ::Importer
    include CanGroupRows

    self.group_by = [:name, :effective_date, :federal_register_notice]

    ENDPOINT = "#{Rails.root}/data/screening_lists/isn/isn.csv"

    COLUMN_HASH = {
      name:                     :name,
      federal_register_notice:  :federal_register_notice,
      effective_date:           :start_date,
      date_liftedwaivedexpired: :end_date,
    }

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      rows = CSV.parse(open(@resource, 'r:ISO-8859-1').read, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      rows = rows.select { |row| !expired?(row) }

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end

      self.class.model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

      doc[:id] = id
      doc[:source] = self.class.model_class.source
      doc[:source_list_url] = 'http://www.state.gov/t/isn/c15231.htm'
      doc[:source_information_url] = 'http://www.state.gov/t/isn/c15231.htm'

      %i(start_date end_date).each do |field|
        doc[field] &&= parse_american_date(doc[field])
      end

      doc[:programs] = rows.map { |row| row[:programs] }

      doc
    end

    def expired?(row)
      parse_american_date(row[:date_liftedwaivedexpired]) < Time.now rescue nil
    end
  end
end
