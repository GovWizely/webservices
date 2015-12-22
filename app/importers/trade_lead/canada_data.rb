require 'open-uri'
require 'csv'

module TradeLead
  class CanadaData
    include Importable
    include VersionableResource
    ENDPOINT = 'https://buyandsell.gc.ca/procurement-data/csv/tender/active'
    CONTAINS_MAPPER_LOOKUPS = true

    COLUMN_HASH = {
      language:                             :language,
      title:                                :title,
      reference_number:                     :reference_number,
      solicitation_number:                  :contract_number,
      publication_date:                     :publish_date,
      date_closing:                         :end_date,
      amendment_date:                       :publish_date_amended,
      publishing_status:                    :status,
      gsin:                                 :industry,
      region_opportunity:                   :region_opportunity,
      region_delivery:                      :specific_location,
      notice_type:                          :notice_type,
      trade_agreement:                      :trade_agreement,
      tendering_procedure:                  :bid_type,
      competitive_procurement_strategy:     :competitive_procurement_strategy,
      non_competitive_procurement_strategy: :non_competitive_procurement_strategy,
      procurement_entity:                   :procurement_organization,
      end_user_entity:                      :implementing_entity,
      description:                          :description,
      contact:                              :contact,
      document:                             :urls,
    }.freeze

    def initialize(resource = ENDPOINT)
      @resource = resource
    end

    def import
      TradeLead::Canada.index(leads)
    end

    def leads
      raw = strip_bom(open(@resource, 'r:utf-8').read)
      doc = CSV.parse(raw, headers: true, header_converters: :symbol, encoding: 'UTF-8')
      doc.map { |entry| process_entry entry.to_h }.compact
    end

    private

    def strip_bom(text)
      text.sub(/^\xef\xbb\xbf/, '')
    end

    def process_entry(entry)
      lead = sanitize_entry(remap_keys(COLUMN_HASH, entry))
      return unless lead[:language] =~ /english/i

      %i(publish_date end_date publish_date_amended).each do |field|
        lead[field] = Date.parse(lead[field]).iso8601 rescue nil if lead[field]
      end

      lead = process_additional_fields(lead)
      lead[:source] = TradeLead::Canada.source[:code]
      lead
    end

    def process_additional_fields(lead)
      lead = process_urls(lead)
      lead[:industry] = split_industries(lead[:industry]) if lead[:industry]
      lead[:ita_industries] = lead[:industry] ? get_mapper_terms_from_array(lead[:industry]) : []
      lead[:country] = 'CA'
      lead
    end

    def process_urls(lead)
      lead[:urls] = lead[:urls].split(',').map(&:squish) if lead[:urls]
      lead[:urls] = lead[:urls].map { |url| UrlMapper.get_bitly_url(url, model_class) } if lead[:urls]
      lead
    end

    def split_industries(industry)
      industry.split(/,* *([0-9A-Z]+:)/).delete_if(&:empty?).each_slice(2).map(&:join)
    end
  end
end
