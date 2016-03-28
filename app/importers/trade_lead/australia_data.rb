require 'csv'
require 'open-uri'

module TradeLead
  class AustraliaData
    include Importable
    include VersionableResource

    # Original source: http://data.gov.au/dataset/austender-contract-notice-export
    ENDPOINT = "#{Rails.root}/data/australian_trade_leads/trade_leads_full.csv"
    CONTAINS_MAPPER_LOOKUPS = true

    COLUMN_HASH = {
      agency:             :agency,
      amendment_date:     :publish_date_amended,
      category:           :industry,
      cn_id:              :id,
      value:              :contract_value,
      description:        :description,
      parent_cn_id:       :parent_id,
      procurement_method: :procurement_method,
      status:             :status,
      agency_ref_id:      :project_number,
      publish_date:       :publish_date,
      startdate:          :start_date,
      enddate:            :end_date,
    }

    def loaded_resource
      @loaded_resource ||= open(@resource, 'r:windows-1252:utf-8').read
    end

    def import
      rows = CSV.parse(loaded_resource, headers: true, header_converters: :symbol, encoding: 'windows-1252:utf-8')
      entries = rows.map { |row| process_row row.to_h }.compact
      TradeLead::Australia.index(entries)
    end

    private

    def process_row(row)
      entry = sanitize_entry(remap_keys COLUMN_HASH, row)

      return unless entry[:id]

      entry[:ita_industries] = entry[:industry] ? [normalize_industry(entry[:industry])].compact.flatten.uniq : []
      entry[:publish_date_amended] = parse_date entry[:publish_date_amended] if entry[:publish_date_amended]
      entry[:country] = 'AU'
      entry[:country_name] = 'Australia'
      entry.merge! add_related_fields([entry[:country_name]])
      entry = process_urls(entry)
      entry[:source] = TradeLead::Australia.source[:code]
      entry
    end

    def process_urls(entry)
      entry[:url] = "https://www.tenders.gov.au/?event=public.advancedsearch.keyword&keyword=#{entry[:id]}"
      entry[:url] = UrlMapper.get_bitly_url(entry[:url], model_class) if entry[:url].present?
      entry
    end
  end
end
