require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class UvlData
    include Importable
    include ::VersionableResource

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(address country name)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name)

    include ScreeningList::MakeNameVariants

    ENDPOINT = 'https://www.bis.doc.gov/index.php/forms-documents/doc_download/1053-unverified-list'

    def import
      @source_list_url = UrlMapper.get_bitly_url('http://www.bis.doc.gov/enforcement/unverifiedlist/unverified_parties.html', model_class)
      @source_information_url = UrlMapper.get_bitly_url('http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/unverified-list', model_class)

      rows = CSV.parse(loaded_resource, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      ensure_expected_headers(rows.first)

      docs = group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end

      model_class.index(docs)
    end

    private

    def process_grouped_rows(id, rows)
      doc = {
        name:                   rows.first[:name],
        id:                     id,
        source:                 model_class.source,
        source_list_url:        @source_list_url,
        source_information_url: @source_information_url,
      }

      doc[:addresses] = rows.map do |row|
        { address:     row[:address],
          city:        nil,
          state:       nil,
          postal_code: nil,
          country:     lookup_country(row[:country]), }
      end.uniq

      doc[:alt_names] =
        rows.map { |row| row[:name].split(', a.k.a. ') }
            .flatten
            .uniq
            .delete_if { |alt_name| alt_name == doc[:name] }

      make_names(doc)

      doc
    end
  end
end
