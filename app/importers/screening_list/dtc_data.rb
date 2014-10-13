require 'csv'

module ScreeningList
  class DtcData
    include ::Importer

    ENDPOINT = "#{Rails.root}/data/screening_lists/dtc/itar_debarred_party_list_07142014.csv"

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      rows = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: 'UTF-8')
      entries = rows.map { |row| process_row row.to_h }.compact
      self.class.model_class.index(entries)
    end

    private

    def process_row(row)
      entry = { remarks: row[:notes] }

      entry[:name] =
          %i(debarred_party_given_names
             debarred_party_surnamecorporate_name).map do |key|
            row[key].to_s
          end.join(' ')

      entry[:alt_names] = row[:alias] ? row[:alias].split(';') : []
      entry[:start_date] = parse_american_date(row[:eff_date])
      entry[:federal_register_notice] = row[:corrected_notice] || row[:notice]
      entry[:source] = self.class.model_class.source
      entry[:source_list_url] = 'http://www.pmddtc.state.gov/compliance/debar_intro.html'
      entry[:id] = Digest::SHA1.hexdigest(
          %i(name start_date federal_register_notice).map { |f| entry[f] }.join)

      sanitize_entry(entry)
    end
  end
end
