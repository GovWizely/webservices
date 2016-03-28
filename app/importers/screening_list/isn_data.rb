require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class IsnData
    include Importable
    include ::VersionableResource

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      address address_number address_remarks
      alternate_name alternate_number alternate_remarks alternate_type
      call_sign city country date_liftedwaivedexpired
      effective_date entity_number federal_register_notice
      gross_register_tonnage gross_tonnage license_policy
      license_requirement name postal_code programs
      remarksnotes sdn_type source_list standard_order
      stateprovince title vessel_flag vessel_owner
      vessel_type web_link)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name effective_date federal_register_notice)

    include ScreeningList::MakeNameVariants

    ENDPOINT = "#{Rails.root}/data/screening_lists/isn/isn.csv"

    COLUMN_HASH = {
      name:                     :name,
      federal_register_notice:  :federal_register_notice,
      effective_date:           :start_date,
      date_liftedwaivedexpired: :end_date,
      remarksnotes:             :remarks,
      web_link:                 :source_list_url,
    }

    def loaded_resource
      @loaded_resource ||= open(@resource, 'r:iso-8859-1').read
    end

    def import
      rows = CSV.parse(loaded_resource, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      ensure_expected_headers(rows.first)

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end

      model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

      doc[:id]                     = id
      doc[:source]                 = model_class.source

      doc[:addresses] = rows.map { |row| process_address(row) }.uniq

      %i(start_date end_date).each do |field|
        doc[field] &&= parse_american_date(doc[field])
      end

      doc[:source_list_url] = UrlMapper.get_bitly_url(doc[:source_list_url], model_class)
      doc[:source_information_url] = doc[:source_list_url]

      doc[:programs] = rows.map { |row| row[:programs] }

      make_names(doc)

      doc
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
      address
    end
  end
end
