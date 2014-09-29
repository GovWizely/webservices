require 'csv'
require 'open-uri'

class AustralianTradeLeadData
  include Importer

  # Original source: http://data.gov.au/dataset/austender-contract-notice-export
  ENDPOINT = "#{Rails.root}/data/australian_trade_leads/trade_leads_full.csv"

  COLUMN_HASH = {
    agency:             :agency,
    amendment_date:     :publish_date_amended,
    category:           :topic,
    cn_id:              :id,
    value:              :contract_value,
    description:        :description,
    parent_cn_id:       :parent_id,
    procurement_method: :procurement_method,
    status:             :status,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    rows = CSV.read(@resource, headers: true, header_converters: :symbol, encoding: 'windows-1252:utf-8')
    entries = rows.map { |row| process_row row.to_h }.compact
    AustralianTradeLead.index entries
  end

  private

  def process_row(row)
    entry = sanitize_entry(remap_keys COLUMN_HASH, row)

    return unless entry[:id]

    entry[:publish_date_amended] = parse_date entry[:publish_date_amended] if entry[:publish_date_amended]
    entry[:countries] = 'AU'
    entry[:url] = "https://www.tenders.gov.au/?event=public.advancedsearch.keyword&keyword=#{entry[:id]}"
    entry
  end
end
