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
      model_class.index(entries)
    end

    private

    def rows
      r = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: 'UTF-8', col_sep: "\t").map(&:to_h)

      ensure_expected_headers(r.first)
      r
    end

    def entries
      group_rows(rows).map do |id, grouped|
        process_grouped_rows(id, grouped)
      end.compact
    end

    def empty_entry?(entry)
      entry.values.all?(&:empty?)
    end

    def process_grouped_rows(id, rows)
      entry = remap_keys(COLUMN_HASH, rows.first)

      return nil if empty_entry?(entry)

      entry[:id]                     = id
      entry[:source]                 = model_class.source
      entry[:source_list_url]        =
        'http://www.bis.doc.gov/index.php/the-denied-persons-list'
      entry[:source_information_url] =
        'http://www.bis.doc.gov/index.php/policy-guidance/lists-of-parties-of-concern/denied-persons-list'

      stopwords   = %w(and the los)
      common_words = %w(co company corp corporation inc incorporated limited ltd mr mrs ms organization sa sas llc)

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

      entry[:name_idx]      = entry[:name].gsub(/[[:punct:]]/, ' ').squeeze(' ')
      entry[:name_idx]      = entry[:name_idx].split.delete_if { |name| stopwords.include?(name.downcase) }.join(' ')
      entry[:rev_name]      = entry[:name_idx].split.reverse.join(' ')
      entry[:trim_name]     = entry[:name_idx].gsub(/\s+/, '')
      entry[:trim_rev_name] = entry[:rev_name].gsub(/\s+/, '')

      if !(entry[:name_idx].downcase.split & common_words).empty?
        entry[:name_no_common]          = entry[:name_idx].split.delete_if { |name| common_words.include?(name.downcase) }.join(' ')
        entry[:rev_name_no_common]      = entry[:name_no_common].split.reverse.join(' ')
        entry[:trim_name_no_common]     = entry[:name_no_common].gsub(/\s+/, '')
        entry[:trim_rev_name_no_common] = entry[:rev_name_no_common].gsub(/\s+/, '')
      end

      %i(start_date end_date).each do |field|
        entry[field] &&= parse_american_date(entry[field])
      end

      entry[:addresses] = rows.map do |row|
        remap_keys(ADDRESS_HASH, row)
      end
      entry
    end
  end
end
