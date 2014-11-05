require 'csv'
require 'digest/md5'

module TariffRate
  module Importer
    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :default_endpoint, :country_code
        end
      end
    end

    COLUMN_HASH = {
      id:                        :source_id,
      tl:                        :tariff_line,
      tl_desc:                   :description,
      hs6:                       :hs_6,
      sector_code:               :sector_code,
      base_rate:                 :base_rate,
      base_rate_alt:             :base_rate_alt,
      final_year:                :final_year,
      tls_per_6_digit:           :tariff_lines_per_6_digit,
      trq_quota:                 :tariff_rate_quota,
      trq_note:                  :tariff_rate_quota_note,
      tariff_eliminated:         :tariff_eliminated,
      product_type:              :product_type_id,
      pending_data:              :pending_data,
      ag_id:                     :ag_id,
      partnername:               :partner_name,
      reportername:              :reporter_name,
      stagingbasket:             :staging_basket,
      stagingbasketid:           :staging_basket_id,
      num_mar_columns:           :num_mar_columns,
      partnerstartyear:          :partner_start_year,
      reporterstartyear:         :reporter_start_year,
      partneragreementname:      :partner_agreement_name,
      reporteragreementname:     :reporter_agreement_name,
      partneragreementapproved:  :partner_agreement_approved,
      reporteragreementapproved: :reporter_agreement_approved,
      rule_text:                 :rule_text,
      link_text:                 :link_text,
      link_url:                  :link_url,
      quotaname:                 :quota_name,
      producttype:               :industry,
    }

    def initialize(resource = nil)
      @resource = resource || self.class.default_endpoint
    end

    def import
      Rails.logger.info "Importing #{@resource}"
      rows = CSV.parse(open(@resource).read, headers: true, header_converters: :symbol, encoding: 'UTF-8')
      entries = rows.map { |row| process_row row.to_h }.compact
      model_class.index(entries)
    end

    private

    def process_row(row)
      row.each { |_k, v| row[_k] = nil if v == '(null)' }

      entry = sanitize_entry(remap_keys(COLUMN_HASH, row))
      entry[:id] = Digest::SHA1.hexdigest(row.to_s)

      entry.merge!(extract_rate_by_year_fields(row))
      entry.merge!(extract_country_fields(entry))

      entry[:tariff_rate_quota_note] = Sanitize.clean(entry[:tariff_rate_quota_note])
      entry[:source] = model_class.source
      entry
    end

    def extract_rate_by_year_fields(row)
      rate_by_year = {}
      alt_rate_by_year = {}
      row.each do |key, value|
        rate_by_year[key.to_s] = value.to_s if key.to_s.start_with?('y20') && !value.nil?
        alt_rate_by_year[key.to_s] = value.to_s if key.to_s.start_with?('alt_20') && !value.nil?
      end
      { annual_rates:     rate_by_year,
        alt_annual_rates: alt_rate_by_year }
    end

    def extract_country_fields(entry)
      country_fields = { countries: ['US', self.class.country_code] }
      %i(partner_name reporter_name partner_agreement_name reporter_agreement_name).each do |name|
        country_fields[name] = lookup_country(entry[name])
      end
      country_fields
    end
  end
end
