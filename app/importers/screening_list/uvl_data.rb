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

      stopwords                     = %w(and the los)
      common_words                  = %w(co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc)

      ##
      # index 2 forms of each name for both "name" and "alt_names",
      # one with punctuation and "stopwords" removed and
      # one the above plus "common" words removed.
      #
      # then store additional modified versions of the two in the following ways:
      #
      #     1) reversed
      #     2) with white space removed
      #     3) reversed with white space removed
      #

      doc[:name_idx]      = doc[:name].gsub(/[[:punct:]]/, ' ').squeeze(' ')
      doc[:name_idx]      = doc[:name_idx].split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')
      doc[:rev_name]      = doc[:name_idx].split.reverse.join(' ')
      doc[:trim_name]     = doc[:name_idx].gsub(/\s+/, '')
      doc[:trim_rev_name] = doc[:rev_name].gsub(/\s+/, '')

      if !(doc[:name_idx].downcase.split & common_words).empty?
        doc[:name_no_common]          = doc[:name_idx].split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')
        doc[:rev_name_no_common]      = doc[:name_no_common].split.reverse.join(' ')
        doc[:trim_name_no_common]     = doc[:name_no_common].gsub(/\s+/, '')
        doc[:trim_rev_name_no_common] = doc[:rev_name_no_common].gsub(/\s+/, '')
      end

      if doc[:alt_names].present?
        doc[:alt_names_idx]          = doc[:alt_names].map { |name| name.gsub(/[[:punct:]]/, '').squeeze(' ') }
        doc[:alt_names_idx]          = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| stopwords.include?(word.downcase) }.join(' ') }
        doc[:rev_alt_names]          = doc[:alt_names_idx].map { |name| name.split.reverse.join(' ') }
        doc[:trim_alt_names]         = doc[:alt_names_idx].map { |name| name.gsub(/\s+/, '') }
        doc[:trim_rev_alt_names]     = doc[:rev_alt_names].map { |name| name.gsub(/\s+/, '') }

        if !(doc[:alt_names_idx].map!(&:downcase).join(' ').split & common_words).empty?
          doc[:alt_names_no_common]    = doc[:alt_names_idx].map { |name| name.split.delete_if { |word| common_words.include?(word.downcase) }.join(' ') }
          doc[:rev_alt_no_common]      = doc[:alt_names_no_common].map { |name| name.split.reverse.join(' ') }
          doc[:trim_alt_no_common]     = doc[:alt_names_no_common].map { |name| name.gsub(/\s+/, '') }
          doc[:trim_rev_alt_no_common] = doc[:rev_alt_no_common].map { |name| name.gsub(/\s+/, '') }
        end
      end

      doc
    end
  end
end
