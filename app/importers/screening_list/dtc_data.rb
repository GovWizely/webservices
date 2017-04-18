require 'csv'

module ScreeningList
  class DtcData
    include Importable
    include ::VersionableResource

    include ::CanEnsureCsvHeaders
    self.expected_csv_headers = %i(
      corrected_notice corrected_notice_date
      date_of_birth debarred_party_full_name_and_alias
      notice notice_date)

    # We don't group source entries in this importer, but we want
    # to use the generate_id method brought in by this module.
    include ScreeningList::CanGroupRows
    self.group_by = %i(name start_date federal_register_notice)

    include ScreeningList::MakeNameVariants

    ENDPOINT = "#{Rails.root}/data/screening_lists/dtc/itar_debarred_party_list_04172017.csv"

    def import
      @source_information_url = UrlMapper.get_bitly_url('http://www.pmddtc.state.gov/compliance/debar_intro.html', model_class)
      @source_list_url = UrlMapper.get_bitly_url('http://www.pmddtc.state.gov/compliance/debar.html', model_class)
      @admin_source_list_url = UrlMapper.get_bitly_url('http://www.pmddtc.state.gov/compliance/debar_admin.html', model_class)

      rows = CSV.parse(loaded_resource, headers: true, header_converters: :symbol, encoding: 'UTF-8')

      ensure_expected_headers(rows.first)

      entries = rows.map { |row| process_row row.to_h }.compact
      model_class.index(entries)
    end

    private

    def process_row(row)
      doc = {
        name:                    extract_name(row),
        alt_names:               extract_alt_names(row),
        federal_register_notice: (row[:corrected_notice] || row[:notice]),
        source:                  model_class.source,
        source_information_url:  @source_information_url,
      }

      make_names(doc)

      doc[:source_list_url] = row[:type] == 'Administrative' ? @admin_source_list_url : @source_list_url

      doc[:id] = generate_id(doc)
      sanitize_entry(doc)
    end

    def extract_name(row)
      name = row[:debarred_party_full_name_and_alias]
      if name.include? 'Inc.'
        name
      else
        name.sub(/\(.*\)/, '').sub(/(.*),(.*)/, '\2 \1')
      end
    end

    def extract_alt_names(row)
      name = row[:debarred_party_full_name_and_alias]
      if name.include? 'a.k.a.'
        name.sub(/.*(\(a.*\))/, '\1').sub('(a.k.a. ', '').sub(')', '').split('; ')
      else
        []
      end
    end
  end
end
