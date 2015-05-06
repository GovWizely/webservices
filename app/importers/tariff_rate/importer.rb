require 'csv'
require 'digest/md5'

module TariffRate
  module Importer
    def self.included(base)
      base.class_eval do
        class << self
          attr_accessor :default_endpoint
        end
      end
    end

    CSV_HEADERS = [:id, :tl, :tl_desc, :hs6, :sector_code, :base_rate, :base_rate_alt, :final_year, :tls_per_6_digit,
                   :staging_basket, :trq_quota, :trq_note, :tariff_eliminated, :product_type, :pending_data,
                   :ag_id, :partnername, :reportername, :stagingbasket, :stagingbasketid, :num_mar_columns,
                   :partnerstartyear, :reporterstartyear, :partneragreementname, :reporteragreementname,
                   :partneragreementapproved, :reporteragreementapproved, :rule_text1, :link_text1, :link_url1,
                   :rule_text2, :link_text2, :link_url2, :quotaname, :producttype, :y2004, :alt_2004, :y2005,
                   :alt_2005, :y2006, :alt_2006, :y2007, :alt_2007, :y2008, :alt_2008, :y2009, :alt_2009,
                   :y2010, :alt_2010, :y2011, :alt_2011, :y2012, :alt_2012, :y2013, :alt_2013, :y2014, :alt_2014,
                   :y2015, :alt_2015, :y2016, :alt_2016, :y2017, :alt_2017, :y2018, :alt_2018, :y2019, :alt_2019,
                   :y2020, :alt_2020, :y2021, :alt_2021, :y2022, :alt_2022, :y2023, :alt_2023, :y2024, :alt_2024,
                   :y2025, :alt_2025, :y2026, :alt_2026, :y2027, :alt_2027, :y2028, :alt_2028, :y2029, :alt_2029,
                   :y2030, :alt_2030, :y2031, :alt_2031]

    COLUMN_HASH = {
      id:                        :source_id,
      tl:                        :tariff_line,
      tl_desc:                   :subheading_description,
      hs6:                       :hs_6,
      base_rate:                 :base_rate,
      base_rate_alt:             :base_rate_alt,
      final_year:                :final_year,
      trq_quota:                 :tariff_rate_quota,
      trq_note:                  :tariff_rate_quota_note,
      tariff_eliminated:         :tariff_eliminated,
      ag_id:                     :ag_id,
      partnername:               :partner_name,
      reportername:              :reporter_name,
      stagingbasket:             :staging_basket,
      partnerstartyear:          :partner_start_year,
      reporterstartyear:         :reporter_start_year,
      partneragreementname:      :partner_agreement_name,
      reporteragreementname:     :reporter_agreement_name,
      partneragreementapproved:  :partner_agreement_approved,
      reporteragreementapproved: :reporter_agreement_approved,
      quotaname:                 :quota_name,
    }

    def initialize(resource = nil, s3 = nil)
      @resource = resource || self.class.default_endpoint
      @s3 = s3 || Aws::S3::Client.new(
                    region:      Rails.configuration.tariff_rate[:aws][:region],
                    credentials: Aws::Credentials.new(
                                  Rails.configuration.tariff_rate[:aws][:access_key_id],
                                  Rails.configuration.tariff_rate[:aws][:secret_access_key]))
    end

    def import
      object = @s3.get_object(bucket: 'tariffs', key: "#{@resource}").body

      options = {
        quote_char:                "'",
        chunk_size:                500,
        user_provided_headers:     CSV_HEADERS,
        convert_values_to_numeric: false }

      SmarterCSV.process(object, options) do |chunk|
        entries = chunk.map { |row| process_row row }.compact
        model_class.index entries
      end
    end

    def process_row(row_hash)
      row_hash.symbolize_keys!
      row_hash.each { |_k, v| row_hash[_k] = nil if v == '(null)' || v == 'N/A' }

      entry = sanitize_entry(remap_keys(COLUMN_HASH, row_hash))
      entry.merge!(extract_duplicate_fields(row_hash))

      entry[:id] = Digest::SHA1.hexdigest(row_hash.to_s)

      entry.merge!(extract_rate_by_year_fields(row_hash))
      entry.merge!(extract_country_fields(entry))

      entry[:tariff_rate_quota_note] = Sanitize.clean(entry[:tariff_rate_quota_note])
      entry[:source] = model_class.source[:code]
      entry
    end

    def extract_duplicate_fields(row)
      { rule_text: row[:rule_text1].nil? ? row[:rule_text2] : row[:rule_text1],
        link_text: row[:link_text1].nil? ? row[:link_text2] : row[:link_text1],
        link_url:  row[:link_url1].nil? ? row[:link_url2] : row[:link_url1] }
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
      country_fields = {}
      %i(partner_name reporter_name partner_agreement_name reporter_agreement_name).each do |name|
        country_fields[name] = lookup_country(entry[name])
      end
      country_fields
    end
  end
end
