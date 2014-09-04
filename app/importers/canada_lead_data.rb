require 'open-uri'
require 'csv'

class CanadaLeadData
  include Importer
  ENDPOINT = "https://buyandsell.gc.ca/procurement-data/csv/tender/active"

  COLUMN_HASH = {
    language:                              :language,
    title:                                 :title,
    reference_number:                      :reference_number,
    solicitation_number:                   :contract_number,
    publication_date:                      :publish_date,
    date_closing:                          :end_date,
    amendment_date:                        :publish_date_amended,
    publishing_status:                     :status,
    gsin:                                  :industry,
    region_opportunity:                    :region_opportunity,
    region_delivery:                       :specific_location,
    notice_type:                           :notice_type,
    trade_agreement:                       :trade_agreement,
    tendering_procedure:                   :bid_type,
    competitive_procurement_strategy:      :competitive_procurement_strategy,
    non_competitive_procurement_strategy:  :non_competitive_procurement_strategy,
    procurement_entity:                    :procurement_organization,
    end_user_entity:                       :implementing_entity,
    description:                           :description,
    contact:                               :contact,
    document:                              :urls
  }.freeze

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    CanadaLead.index leads
  end

  def leads
    doc = CSV.parse(open(@resource, 'r:UTF-8').read, headers: true, header_converters: :symbol, encoding: "UTF-8")
    doc.map { |entry| process_entry entry.to_h }.compact
  end

  private

  def process_entry(entry)
    lead = sanitize_entry(remap_keys(COLUMN_HASH, entry))
    return unless lead[:language] =~ /english/i

    %i(publish_date end_date publish_date_amended).each do |field|
      lead[field] = Date.parse(lead[field]).iso8601 rescue nil if lead[field]
    end

    lead[:urls] = lead[:urls].split(',').map(&:squish) if lead[:urls]

    lead[:country] = 'CA'
    lead
  end
end
