require 'open-uri'
require 'csv'
require 'digest/md5'

module ScreeningList
  class UvlData
    include ::Importer

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(address country name)

    include ScreeningList::CanGroupRows
    self.group_by = %i(name)

    ENDPOINT = 'http://www.bis.doc.gov/index.php/forms-documents/doc_download/1053-unverified-list'

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      rows = CSV.parse(open(@resource).read, encoding: 'UTF-8').map do |row|
        { country: row[0],
          name:    row[1],
          address: row[2] }
      end

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
        source_list_url:        'http://www.bis.doc.gov/enforcement/unverifiedlist/unverified_parties.html',
        source_information_url: 'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/unverified-list',
      }

      doc[:addresses] = rows.map do |row|
        { address:     row[:address],
          city:        nil,
          state:       nil,
          postal_code: nil,
          country:     lookup_country(row[:country]) }
      end.uniq

      doc[:alt_names] =
        rows.map { |row| row[:name].split(', a.k.a. ') }
        .flatten
        .uniq
        .delete_if { |alt_name| alt_name == doc[:name] }
          .delete_if { |alt_name| alt_name == doc[:name] }

      stops  =  ['co','company','corp','corporation','inc','incorporated',
                 'limited','ltd','mr','mrs','ms','organization',
                 'sa','sas','llc', 'and', 'the', 'los']

      doc[:name] = doc[:name].gsub(/[.,]/, '')
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
  end
end
