require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class ElData
    include Importable
    include ::VersionableResource

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      address address_number address_remarks alternate_name alternate_number
      alternate_remarks alternate_type call_sign city country
      date_liftedwaivedexpired effective_date entity_number
      federal_register_notice gross_register_tonnage gross_tonnage
      license_policy license_requirement name postal_code programs remarksnotes
      sdn_type source_list standard_order stateprovince title vessel_flag
      vessel_owner vessel_type web_link)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name federal_register_notice effective_date)

    include ScreeningList::MakeNameVariants

    ENDPOINT = 'https://www.bis.doc.gov/index.php/forms-documents/doc_download/1072-el'

    COLUMN_HASH = {
      name:                    :name,
      federal_register_notice: :federal_register_notice,
      effective_date:          :start_date,
      standard_order:          :standard_order,
      license_requirement:     :license_requirement,
      license_policy:          :license_policy,
      web_link:                :source_list_url,
      title:                   :title,
    }

    def import
      rows = CSV.parse(loaded_resource, headers: true, header_converters: [:symbol])
      ensure_expected_headers(rows.first)
      @source_list_url = 'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/entity-list'
      docs = group_rows(rows).map { |id, grouped| process_grouped_rows(id, grouped) }
      model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)

      doc[:id] = id

      doc[:alt_names] = rows.map do |row|
        strip_nonascii(row[:alternate_name])
      end.compact.uniq

      doc[:title] = rows.map do |row|
        strip_nonascii(row[:title])
      end.compact.uniq
      doc[:title] = doc[:title].join('; ').presence || nil

      doc[:addresses] = rows.map { |row| process_address(row) }.uniq

      doc[:start_date] &&= parse_american_date(doc[:start_date])
      doc[:source]          = model_class.source
      doc[:source_list_url] = UrlMapper.get_bitly_url(@source_list_url, model_class)
      doc[:source_information_url] = UrlMapper.get_bitly_url(@source_list_url, model_class)

      make_names(doc)

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
