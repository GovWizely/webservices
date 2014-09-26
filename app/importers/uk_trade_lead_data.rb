require 'open-uri'
require 'csv'

class UkTradeLeadData
  include Importer

  # Could implement some params here to fetch historical data
  ENDPOINT = 'https://online.contractsfinder.businesslink.gov.uk/PublicFileDownloadHandler.ashx?fileName=notices.csv&recordType=Notices&fileContent=Recent'

  COLUMN_HASH = {
    noticeid:         :id,
    referencenumber:  :reference_number,
    datepublished:    :publish_date,
    valuemin:         :min_contract_value,
    valuemax:         :max_contract_value,
    status:           :status,
    url:              :url,
    org_name:         :procurement_organization,
    org_contactemail: :contact,
    title:            :title,
    description:      :description,
    noticetype:       :notice_type,
    region:           :specific_location,
    classification:   :industry,
  }

  def initialize(resource = ENDPOINT)
    @resource = resource
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    file = open @resource
    file.readline # hack to remove first line from csv
    rows = CSV.parse(file, headers: true, header_converters: :symbol, encoding: 'windows-1252:utf-8')
    entries = []
    rows.each do |row|
      next if %w(archived retracted).include? row[:status].downcase
      entries << process_row(row.to_h)
    end
    UkTradeLead.index entries
  end

  private

  def process_row(row)
    entry = remap_keys(COLUMN_HASH, row)
    entry[:publish_date] = parse_date(entry[:publish_date])
    %i(description title procurement_organization contact).each do |key|
      entry[key] = sanitize(entry[key])
    end
    entry[:country] = 'GB'
    entry
  end

  def sanitize(entry_key)
    Nokogiri::HTML.fragment(entry_key).inner_text.squish if entry_key.present?
  end
end
