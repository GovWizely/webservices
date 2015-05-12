require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class ElData
    include ::Importer

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

    ENDPOINT = 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1072-el'

    COLUMN_HASH = {
      name:                    :name,
      federal_register_notice: :federal_register_notice,
      effective_date:          :start_date,
      standard_order:          :standard_order,
      license_requirement:     :license_requirement,
      license_policy:          :license_policy,
      web_link:                :source_list_url,
    }

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      rows = CSV.parse(open(@resource, 'r:iso-8859-1:utf-8').read,
                       headers:           true,
                       header_converters: :symbol)

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

      doc[:alt_names] = rows.map do |row|
        strip_nonascii(row[:alternate_name])
      end.compact.uniq

      doc[:addresses] = rows.map { |row| process_address(row) }.uniq

      doc[:start_date] &&= parse_american_date(doc[:start_date])
      doc[:source] = model_class.source
      doc[:source_list_url] =
        doc[:source_information_url] =
        'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/entity-list'

      stops  =  ['co','company','corp','corporation','inc','incorporated',
                 'limited','ltd','mr','mrs','ms','organization',
                 'sa','sas','llc', 'and', 'the', 'los']

      doc[:name] = doc[:name].gsub(/,/, '')
      doc[:name_nostop] = doc[:name].split.delete_if{|x| stops.include?(x.downcase)}.join(' ')

      doc[:rev_name] = doc[:name].split.reverse.join(' ')
      doc[:trim_name] = doc[:name].gsub(/\s+/, '')
      doc[:trim_rev_name] = doc[:rev_name].gsub(/\s+/, '')

      doc[:alt_names] = doc[:alt_names].map{ |name| name.gsub(/,/, '') }
      doc[:rev_alt_names] = doc[:alt_names].map{ |name| name.split.reverse.join(' ') }
      doc[:trim_alt_names] = doc[:alt_names].map{ |name| name.gsub(/\s+/, '') }
      doc[:trim_rev_alt_names] = doc[:rev_alt_names].map{ |name| name.gsub(/\s+/, '') }
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
