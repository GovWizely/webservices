require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class ElData
    include ::Importer
    include CanGroupRows

    self.group_by = [:name, :federal_register_notice, :effective_date]

    ENDPOINT = 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1072-el'

    COLUMN_HASH = {
      entity_number:            :entity_number,
      sdn_type:                 :type,
      programs:                 :programs,
      name:                     :name,
      title:                    :title,
      federal_register_notice:  :federal_register_notice,
      effective_date:           :start_date,
      date_liftedwaivedexpired: :end_date,
      standard_order:           :standard_order,
      license_requirement:      :license_requirement,
      license_policy:           :license_policy,
      web_link:                 :source_list_url,
    }

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      Rails.logger.info "Importing #{@resource}"

      rows = CSV.parse(open(@resource, 'r:iso-8859-1:utf-8').read,
                       headers:           true,
                       header_converters: :symbol)

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end

      self.class.model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

      doc[:id] = id

      doc[:alt_names] = rows.map do |row|
        strip_nonascii(row[:alternate_name])
      end.compact.uniq

      doc[:addresses] = rows.map { |row| process_address(row) }.uniq

      doc[:start_date] &&= parse_american_date(doc[:start_date])
      doc[:source] = self.class.model_class.source
      doc[:source_list_url] =
        doc[:source_information_url] =
        'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/entity-list'

      doc
    end

    def strip_nonascii(str)
      str.present? ? str.delete("^\u{0000}-\u{007F}").squish : nil
    end

    ADDRESS_HASH = {
      address:       :address,
      city:          :city,
      country:       :country,
      postal_code:   :postal_code,
      stateprovince: :state,
    }

    def process_address(row)
      address = remap_keys(ADDRESS_HASH, row.to_hash)
      address[:country] &&= lookup_country(address[:country])
      address
    end
  end
end
