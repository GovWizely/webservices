require 'csv'

module ScreeningList
  class DtcData
    include ::Importer

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      alias corp corrected_notice corrected_notice_date
      date_of_birth__public_release debarred_party_full_name
      debarred_party_given_names debarred_party_surnamecorporate_name eff_date
      notice notice_date type)

    # We don't group source entries in this importer, but we want
    # to use the generate_id method brought in by this module.
    include ScreeningList::CanGroupRows
    self.group_by = %i(name start_date federal_register_notice)

    include ScreeningList::MakeNameVariants

    ENDPOINT = "#{Rails.root}/data/screening_lists/dtc/itar_debarred_party_list_07142014.csv"

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      rows = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      ensure_expected_headers(rows.first)

      entries = rows.map { |row| process_row row.to_h }.compact
      model_class.index(entries)
    end

    private

    def process_row(row)
      doc = {
        name:                    extract_name(row),
        alt_names:               extract_alt_names(row),
        start_date:              parse_american_date(row[:eff_date]),
        federal_register_notice: (row[:corrected_notice] || row[:notice]),
        source:                  model_class.source,
        source_information_url:  'http://www.pmddtc.state.gov/compliance/debar_intro.html',
      }

      make_names(doc)

      doc[:source_list_url] = row[:type] == 'Administrative' ?
        'http://www.pmddtc.state.gov/compliance/debar_admin.html' :
        'http://www.pmddtc.state.gov/compliance/debar.html'

      doc[:id] = generate_id(doc)
      sanitize_entry(doc)
    end

    def extract_name(row)
      %i(debarred_party_given_names
         debarred_party_surnamecorporate_name).map do |key|
        row[key].to_s
      end.join(' ')
    end

    def extract_alt_names(row)
      row[:alias] ? row[:alias].split(';') : []
    end
  end
end
