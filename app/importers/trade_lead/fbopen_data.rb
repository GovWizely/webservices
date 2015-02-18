require 'open-uri'

module TradeLead
  class FbopenData
    include Importer

    XPATHS = {
      publish_date:                     '//DATE',
      procurement_organization:         '//AGENCY',
      procurement_office:               '//OFFICE',
      procurement_organization_address: '//LOCATION',
      classification_code:              '//CLASSCOD',
      industry:                         '//NAICS',
      procurement_office_address:       '//OFFADD',
      title:                            '//SUBJECT',
      contract_number:                  '//SOLNBR',
      end_date:                         '//RESPDATE',
      contact:                          '//CONTACT',
      description:                      '//DESC',
      url:                              '//LINK',
      competitive_procurement_strategy: '//SETASIDE',
      specific_location:                '//POPCOUNTRY',
      specific_address:                 '//POPADDRESS',
    }

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

    FULL_XML = 'ftp://ftp.fbo.gov/datagov/FBOFullXML.xml'

    def default_endpoint
      date = 24.hours.ago.in_time_zone('Pacific Time (US & Canada)').strftime('%Y%m%d')
      "ftp://ftp.fbo.gov/FBOFeed#{date}"
    end

    def initialize(resource = nil, resource_full = nil, encoding = 'ISO8859-1')
      @resource = resource || default_endpoint
      @encoding = encoding
      @resource_full = resource_full || FULL_XML
    end

    def import(purge = nil)
      Rails.logger.info "Importing #{@resource}"

      entries = []
      if purge != 'no_purge'
        entries = import_full_xml
        entries = entries.map { |entry| process_xml_entry(entry) }.compact
      end

      TradeLead::Fbopen.index leads + entries
    end

    def leads
      fh = open(@resource, "r:#{@encoding}")
      doc = FbopenParser.new.convert(fh)
      doc.map { |e| process_entry(e) }.compact
    end

    private

    def process_entry(entry)
      return unless %w(PRESOL COMBINE MOD).include?(entry['ntype'])
      return if %w(US USA).include?(entry['POPCOUNTRY'].try(:upcase))

      entry['DATE']     &&= Date.strptime("#{entry['YEAR']}#{entry['DATE']}", '%y%m%d').iso8601
      entry['RESPDATE'] &&= Date.strptime(entry['RESPDATE'], '%m%d%y').iso8601

      lead = sanitize_entry(remap_keys(COLUMN_HASH, entry))

      lead[:description] &&= Nokogiri::HTML.fragment(lead[:description]).inner_text.squish
      lead[:source] = TradeLead::Fbopen.source[:code]
      lead[:id]      = lead[:contract_number]
      EMPTY_RECORD.dup.merge(lead)
    end

    def import_full_xml
      entries = []
      open(@resource_full) do |file|
        Nokogiri::XML::Reader.from_io(file).each do |node|
          if %w(PRESOL COMBINE MOD).include?(node.name) && node.node_type == Nokogiri::XML::Reader::TYPE_ELEMENT
            entry = extract_fields(Nokogiri::XML(node.outer_xml), XPATHS)
            entry[:notice_type] = node.name
            entries << entry
          end

        end
      end
      entries
    end

    def process_xml_entry(entry)
      entry.symbolize_keys!
      return nil if %w(US USA).include?(entry[:specific_location].try(:upcase))

      entry = process_xml_dates(entry)
      unless entry[:end_date].nil?
        return nil if entry[:end_date] < Date.today
      end

      entry[:description] &&= Nokogiri::HTML.fragment(entry[:description]).inner_text.squish
      entry[:contact] &&= Nokogiri::HTML.fragment(entry[:contact]).inner_text.squish
      entry[:source] = TradeLead::Fbopen.source[:code]
      entry[:id]      = entry[:contract_number]
      entry
    end

    def process_xml_dates(entry)
      if entry[:publish_date] =~ /[0-9]{8}/
        entry[:publish_date] &&=  Date.strptime(entry[:publish_date], '%m%d%Y')
      else
        entry[:publish_date] = nil
      end

      if entry[:end_date] =~ /[0-9]{8}/
        entry[:end_date] &&= Date.strptime(entry[:end_date], '%m%d%Y')
      else
        entry[:end_date] = nil
      end
      entry
    end
  end
end
