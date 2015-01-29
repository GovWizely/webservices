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
      Rails.logger.info "Importing #{@resource}"

      object = @s3.get_object(bucket: 'tariffs', key: "#{@resource}").body
      rows = CSV.parse(object.read.force_encoding('utf-8'), headers: true, header_converters: :symbol, encoding: 'UTF-8', quote_char: "'")
      entries = rows.map { |row| process_row row }.compact

      model_class.index(entries)
    end

    private

    def process_row(row)
      row_hash = row.to_h
      row_hash.each { |_k, v| row_hash[_k] = nil if v == '(null)' }

      entry = sanitize_entry(remap_keys(COLUMN_HASH, row_hash))
      entry = extract_duplicate_fields(row, entry)

      entry[:id] = Digest::SHA1.hexdigest(row_hash.to_s)

      entry.merge!(extract_rate_by_year_fields(row_hash))
      entry.merge!(extract_country_fields(entry))

      entry[:tariff_rate_quota_note] = Sanitize.clean(entry[:tariff_rate_quota_note])
      entry[:source] = model_class.source[:code]
      entry
    end

    def extract_duplicate_fields(row, entry)
      rule_text_pos = row.index(:rule_text)

      if (row.headers[rule_text_pos + 1] == :link_text) && (row.headers[rule_text_pos + 2] == :link_url) &&
        (row.headers[rule_text_pos + 3] == :rule_text) && (row.headers[rule_text_pos + 4] == :link_text) &&
        (row.headers[rule_text_pos + 5] == :link_url)

        entry[:rule_text] = row[rule_text_pos] == '(null)' ? row[rule_text_pos + 3] : row[rule_text_pos]
        entry[:link_text] = row[rule_text_pos + 1] == '(null)' ? row[rule_text_pos + 4] : row[rule_text_pos + 1]
        entry[:link_url] = row[rule_text_pos + 2] == '(null)' ? row[rule_text_pos + 5] : row[rule_text_pos + 2]
      else
        fail 'Positioning of duplicate columns does not match the expected format: rule_text, link_text, link_url, rule_text, link_text, link_url'
      end

      entry.each { |_k, v| entry[_k] = nil if v == '(null)' }
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
