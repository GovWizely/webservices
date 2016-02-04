require 'open-uri'

module TradeLead
  module FbopenImporter
    class PatchData
      include Importable
      include FbopenHelpers
      attr_accessor :naics_mapper

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
        'ARCHDATE'   => :arch_date,
        'RESPDATE'   => :resp_date,
        'CONTACT'    => :contact,
        'DESC'       => :description,
        'SETASIDE'   => :competitive_procurement_strategy,
        'LINK'       => :url,
        'POPCOUNTRY' => :country,
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
        country:                          '',
        specific_address:                 '',
        contract_number:                  nil,
        publish_date:                     nil,
        end_date:                         nil,
      }.freeze

      def default_endpoint
        date = 24.hours.ago.in_time_zone('Pacific Time (US & Canada)').strftime('%Y%m%d')
        "ftp://ftp.fbo.gov/FBOFeed#{date}"
      end

      def initialize(resource = nil, encoding = 'ISO8859-1')
        @resource = resource || default_endpoint
        @encoding = encoding
        self.naics_mapper = NaicsMapper.new
      end

      def import
        TradeLead::Fbopen.index(leads)
      end

      def leads
        fh = open(@resource, "r:#{@encoding}")
        doc = FbopenParser.new.convert(fh)
        doc.map { |e| process_entry(e) }.compact
      end

      def can_purge_old?
        false
      end

      def model_class
        TradeLead::Fbopen
      end

      private

      def process_entry(entry)
        return unless valid?(entry)

        entry['DATE'] &&= Date.strptime("#{entry['YEAR']}#{entry['DATE']}", '%y%m%d').iso8601
        entry['RESPDATE'] &&= Date.strptime(entry['RESPDATE'], '%m%d%y').iso8601
        entry['ARCHDATE'] &&= Date.strptime(entry['ARCHDATE'], '%m%d%Y').iso8601

        lead = sanitize_entry(remap_keys(COLUMN_HASH, entry))
        lead[:end_date] = extract_end_date(lead)
        lead.delete(:resp_date)
        lead.delete(:arch_date)

        process_geo_fields(lead)

        lead = process_additional_fields(lead)
        EMPTY_RECORD.dup.merge(lead)
      end

      def process_additional_fields(lead)
        lead[:description] &&= Nokogiri::HTML.fragment(lead[:description]).inner_text.squish
        lead[:source] = TradeLead::Fbopen.source[:code]
        lead[:id]      = lead[:contract_number]
        lead[:url] = UrlMapper.get_bitly_url(lead[:url], model_class) if lead[:url].present?
        lead = process_industries(lead)
        lead
      end

      def valid?(entry)
        valid_type      = %w(PRESOL COMBINE MOD).include?(entry['ntype'])
        valid_country   = entry['POPCOUNTRY'].try(:upcase) =~ /\A[A-Z]{2}\z/
        skipped_country = entry['POPCOUNTRY'] == 'US' if valid_country
        valid_type && valid_country && !skipped_country
      end
    end
  end
end
