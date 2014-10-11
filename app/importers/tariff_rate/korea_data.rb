require 'csv'

module TariffRate
  class KoreaData
    include ::Importer

    ENDPOINT = "#{Rails.root}/data/tariff_rates/korea/korea.csv"

    COLUMN_HASH = {
        id: :source_id,
        tl: :tariff_line,
        tl_desc: :description,
        hs6: :hs_6,
        sector_code: :sector_code,
        base_rate: :base_rate,
        base_rate_alt: :base_rate_alt,
        final_year: :final_year,
        tls_per_6_digit: :tariff_lines_per_6_digit,
        trq_quota: :tariff_rate_quota,
        trq_note: :tariff_rate_quota_note,
        tariff_eliminated: :tariff_eliminated,
        product_type: :product_type_id,
        pending_data: :pending_data,
        ag_id: :ag_id,
        partnername: :partner_name,
        reportername: :reporter_name,
        stagingbasket: :staging_basket,
        stagingbasketid: :staging_basket_id,
        num_mar_columns: :num_mar_columns,
        partnerstartyear: :partner_start_year,
        reporterstartyear: :reporter_start_year,
        partneragreementname: :partner_agreement_name,
        reporteragreementname: :reporter_agreement_name,
        partneragreementapproved: :partner_agreement_approved,
        reporteragreementapproved: :reporter_agreement_approved,
        rule_text: :rule_text,
        link_text: :link_text,
        link_url: :link_url,
        quotaname: :quota_name,
        producttype: :industry,
    }

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
      rate_by_year = {}
      alt_rate_by_year = {}
      row.each do |key, value|
        value.gsub!(/\(null\)/, 'null')
        rate_by_year[key.to_s] = value.to_s if key.to_s.start_with?('y20')
        alt_rate_by_year[key.to_s] = value.to_s if key.to_s.start_with?('alt_20')
      end

      entry = sanitize_entry(remap_keys COLUMN_HASH, row)
      entry[:countries] = 'US,KP'
      entry[:tariff_rate_quota_note] = Sanitize.clean(entry[:tariff_rate_quota_note], whitespace_elements: {})
      entry[:annual_rates] = rate_by_year
      entry[:alt_annual_rates] = alt_rate_by_year

      country_names = [:partner_name, :reporter_name, :partner_agreement_name, :reporter_agreement_name]
      country_names.each do |name|
        entry[name] = lookup_country(entry[name])
      end

      entry[:source] = self.class.model_class.source
      entry
    end
  end
end
