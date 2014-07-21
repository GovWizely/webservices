require 'open-uri'

class FbopenLeadData
  include Importer

  COLUMN_HASH = {
    'ntype'      => :notice_type,
    'DATE'       => :publish_date,
    'AGENCY'     => :procurement_organization,
    'OFFICE'     => :procurement_office,
    'LOCATION'   => :procurement_organization_address,
    'CLASSCOD'   => :classification_code,
    'NAICS'      => :industry,
    'OFFADD'     => :procurement_office_address,
    'SUBJECT'    => :title,
    'SOLNBR'     => :contract_number,
    'RESPDATE'   => :end_date,
    'CONTACT'    => :contact,
    'DESC'       => :description,
    'SETASIDE'   => :competitive_procurement_strategy,
    'LINK'       => :url,
    'POPCOUNTRY' => :specific_location,
    'POPADDRESS' => :specific_address,
  }.freeze

  EMPTY_RECORD = {
    notice_type:                      '',
    procurement_organization:         '',
    procurement_office:               '',
    procurement_organization_address: '',
    classification_code:              '',
    industry:                         '',
    procurement_office_address:       '',
    title:                            '',
    contact:                          '',
    description:                      '',
    competitive_procurement_strategy: '',
    url:                              '',
    specific_location:                '',
    specific_address:                 '',
    contract_number:                  nil,
    publish_date:                     nil,
    end_date:                         nil,
  }.freeze

  def default_endpoint
    date = 24.hours.ago.in_time_zone('Eastern Time (US & Canada)').strftime('%Y%m%d')
    "ftp://ftp.fbo.gov/FBOFeed#{date}"
  end

  def initialize(resource = nil, encoding = 'ISO8859-1')
    @resource = resource || default_endpoint
    @encoding = encoding
  end

  def import
    Rails.logger.info "Importing #{@resource}"
    FbopenLead.index leads
  end

  def leads
    fh = open(@resource, "r:#{@encoding}")
    doc = FbopenParser.new.convert(fh)
    doc.map { |e| process_entry(e) }.compact
  end

  private

  def process_entry(entry)
    return unless %w(PRESOL COMBINE).include?(entry['ntype'])
    return if %w(US USA).include?(entry['POPCOUNTRY'].try(:upcase))

    entry['DATE']     &&= Date.strptime("#{entry['YEAR']}#{entry['DATE']}", '%y%m%d').iso8601
    entry['RESPDATE'] &&= Date.strptime(entry['RESPDATE'], '%m%d%y').iso8601

    lead = sanitize_entry(remap_keys(COLUMN_HASH, entry))

    lead[:description] &&= Nokogiri::HTML.fragment(lead[:description]).inner_text.squish
    lead[:id]      = lead[:contract_number]
    EMPTY_RECORD.dup.merge(lead)
  end
end
