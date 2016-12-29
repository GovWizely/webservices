require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class IsnData
    include Importable
    include ::VersionableResource

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      alternative_names
      country
      effective_date federal_register_notice
      name programs
      remarksnotes source_list
      web_link)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name effective_date federal_register_notice)

    include ScreeningList::MakeNameVariants

    ENDPOINT = 'https://mbcsanctions.t.state.gov/sanctions.csv'

    COLUMN_HASH = {
      name:                    :name,
      federal_register_notice: :federal_register_notice,
      effective_date:          :start_date,
      remarksnotes:            :remarks,
      web_link:                :source_list_url,
      alternative_names:       :alt_names,
      country:                 :country,
    }

    def import
      rows = CSV.parse(loaded_resource, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      ensure_expected_headers(rows.first)

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end.compact

      model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = remap_keys(COLUMN_HASH, rows.first.to_hash)
      return if doc.values.compact.empty?

      doc[:id]                     = id
      doc[:source]                 = model_class.source

      doc[:start_date] &&= parse_american_date(doc[:start_date])

      doc[:source_list_url] = doc[:source_list_url] ? UrlMapper.get_bitly_url(doc[:source_list_url], model_class) : doc[:source_list_url]
      doc[:source_information_url] = doc[:source_list_url]

      doc[:programs] = rows.map { |row| row[:programs] }
      doc[:alt_names] = doc[:alt_names].split(',').map(&:strip) if doc[:alt_names]
      doc[:country] &&= lookup_country(doc[:country])

      make_names(doc)

      doc
    end
  end
end
